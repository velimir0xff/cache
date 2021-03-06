%%%-------------------------------------------------------------------
%%% @author Grigory Starinkin <starinkin@gmail.com>
%%% @doc
%%% Root supervisor module for simple cache application
%%% from book Erlang and OTP in Action
%%% @end
%%% Created :  4 Sep 2013 by Grigory Starinkin <starinkin@gmail.com>
%%%-------------------------------------------------------------------
-module(cache_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @spec init(Args) -> {ok, {SupFlags, [ChildSpec]}} |
%%                     ignore |
%%                     {error, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    %% Supervised modules
    ElementsSup = {cache_element_sup, 
                   {cache_element_sup, start_link, []},
                   permanent, 2000, supervisor, [cache_element_sup]},
    
    CacheEvent = {cache_event,
                  {cache_event, start_link, []},
                  permanent, 2000, worker, [cache_event]}, 

    Childs = [CacheEvent, ElementsSup],
    
    %% Supervisor strategy
    RestartStrategy = one_for_one,
    MaxRestarts = 4,
    MaxSecondsBetweenRestarts = 3600,
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    {ok, {SupFlags, Childs}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
