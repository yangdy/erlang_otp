-module(hello_sup).
-behaviour(supervisor).

%% API functions
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(CHILD(I, Type), {I, start_link, []}, permanent, 5000, Type, [I]).

%% ==================================================================
%% API functions
%% ==================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ==================================================================
%% Supervisor callbacks
%% ==================================================================

%%init([]) ->
%%    {ok, {{one_for_one, 5, 10}, []}}.

init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = 2000,
    Type = worker,

    AChild = {hello_server, {hello_server, start_link, []},
        Restart, Shutdown, Type, [hello_server]},

    {ok, {SupFlags, [AChild]}}.
