-module(cowboy_test_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
	{ok, _} = run(),
	cowboy_test_sup:start_link().

stop(_State) ->
	ok = finish().


-define(HTTP_SERVER, cowboy_test_listener).
-define(HTTPS_SERVER, cowboy_test_ssl_listener).

run() -> run(100).

run(NumAcceptors) ->
	Dispatch = cowboy_router:compile([
		%% {HostMatch, list({PathMatch, Handler, Opts})}
		{'_', [{'_', cowboy_test, []}]}
	]),
	%% Name, NbAcceptors, TransOpts, ProtoOpts
	{ok, _} = cowboy:start_http(?HTTP_SERVER,
		NumAcceptors,
		[{port, 8080}, {max_connections, infinity}],
		[{env, [{dispatch, Dispatch}]}]
	),
	{ok, _} = cowboy:start_https(?HTTPS_SERVER,
		NumAcceptors,
		[{port, 8443},
		 {max_connections, infinity},
		 {certfile, "certs/iosport.co.uk.cert"},
		 {keyfile, "certs/iosport.co.uk.key"}
		],
		[{env, [{dispatch, Dispatch}]}]
	).

finish() ->
	ok = cowboy:stop_listener(?HTTPS_SERVER),
	ok = cowboy:stop_listener(?HTTP_SERVER).
