-module(cowboy_test_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
	folsom_metrics:new_counter(num_requests),
	folsom_metrics:new_histogram(request_time, uniform, 1028),
	run(),
	cowboy_test_sup:start_link().

stop(_State) ->
	finish(),
	lager:info("Outstanding requests: ~p.", [folsom_metrics:get_metric_value(num_requests)]),
	ok.


-define(HTTP_SERVER, cowboy_test_listener).
-define(HTTPS_SERVER, cowboy_test_ssl_listener).

run() -> run(100).

run(NumAcceptors) ->
	Dispatch = cowboy_router:compile([
		%% {HostMatch, list({PathMatch, Handler, Opts})}
		{'_', [{'_', cowboy_test, []}]}
	]),
	%% Name, NbAcceptors, TransOpts, ProtoOpts
	lager:info("HTTP server starting."),
	{ok, _} = cowboy:start_http(?HTTP_SERVER,
		NumAcceptors,
		[{port, 8080}, {max_connections, infinity}],
		[{env, [{dispatch, Dispatch}]}]
	),
	lager:info("HTTP server started."),
	lager:info("HTTPS server starting."),
	{ok, _} = cowboy:start_https(?HTTPS_SERVER,
		NumAcceptors,
		[{port, 8443},
		 {max_connections, infinity},
		 {certfile, "certs/iosport.co.uk.cert"},
		 {keyfile, "certs/iosport.co.uk.key"}
		],
		[{env, [{dispatch, Dispatch}]}]
	),
	lager:info("HTTPS server started.").

finish() ->
	lager:info("HTTPS server stopping."),
	ok = cowboy:stop_listener(?HTTPS_SERVER),
	lager:info("HTTPS server stopped."),
	lager:info("HTTP server stopping."),
	ok = cowboy:stop_listener(?HTTP_SERVER),
	lager:info("HTTP server stopped.").
