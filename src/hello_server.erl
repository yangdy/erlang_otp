-module(hello_server).
-behaviour(gen_server).

-define(SERVER, ?MODULE).

-record(state, {count}).

-export([start_link/0, stop/0, say_hello/0, get_count/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link(
        {local, ?SERVER},
        ?MODULE,
        [],
        []).

stop() ->
    gen_server:cast(?SERVER, stop).

say_hello() ->
    gen_server:cast(?SERVER, say_hello).

get_count() ->
    gen_server:call(?SERVER, get_count).

%% callbacks

init([]) ->
    {ok, #state{count=0}}.

handle_call(get_count, _From, #state{count=Count}) ->
    {reply, Count, #state{count=Count+1}}.

handle_cast(stop, State) ->
    {stop, normal, State};
handle_cast(say_hello, State) ->
    {noreply, #state{count=State#state.count+1}}.

handle_info(Info, State) ->
    io:format("~p~n", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    io:format("terminate~n", []),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

