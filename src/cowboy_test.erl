-module(cowboy_test).
-behaviour(cowboy_loop_handler).

-export([init/3, info/3, terminate/3]).

-record(state, {
	url,
	start_time_ms,
	tref
}).

%% Request Handler

init(_, Req, _Opts) ->
	{ok, TRef} = timer:send_after(5000, timeout),
	folsom_metrics:notify({num_requests, {inc, 1}}),
	{URL, Req2} = cowboy_req:url(Req),
	{loop, Req2, #state{
		url = URL,
		start_time_ms = erlang:system_time(milli_seconds),
		tref = TRef
	}}.

info(timeout, Req, State=#state{url = URL, start_time_ms = Start}) ->
	End = erlang:system_time(milli_seconds),
	{ok, Req2} = cowboy_req:reply(200,
		[{<<"content-type">>, <<"text/plain">>}],
		io_lib:format("~p ms: ~p ~p~n", [End-Start, URL, folsom_metrics:get_metric_value(num_requests)]),
		Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	folsom_metrics:notify({num_requests, {dec, 1}}),
	ok.
