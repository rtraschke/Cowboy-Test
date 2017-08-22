-module(cowboy_test_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
	{ok, _} = run(),
	cowboy_test_sup:start_link().

stop(_State) ->
	ok = finish().


-define(WEBSERVER, cowboy_test_listener).

run() -> run(100).

run(NumAcceptors) ->
	Dispatch = cowboy_router:compile([
		%% {HostMatch, list({PathMatch, Handler, Opts})}
		{'_', [{'_', cowboy_test, []}]}
	]),
	%% Name, NbAcceptors, TransOpts, ProtoOpts
	cowboy:start_http(?WEBSERVER,
		NumAcceptors,
		[{port, 8080}, {max_connections, infinity}],
		[{env, [{dispatch, Dispatch}]}]
	).

finish() ->
	cowboy:stop_listener(?WEBSERVER).
