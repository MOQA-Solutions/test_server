-module(test_server_listener).


-export([start_link/1]).
-export([init/1]).

-export([handle_call/3]).
-export([handle_info/2]).
-export([handle_cast/2]).
-export([code_change/3]).
-export([terminate/2]).


-include("../include/test_server_listener_data.hrl").


-spec start_link(pos_integer()) -> {ok , pid()}.
start_link(Port) ->
	gen_server:start_link(?MODULE , [Port] , []).


init([Port]) ->
	process_flag(trap_exit , true),
	case gen_tcp:listen(Port , ?SOCKOPTS) of
		{ok , ListenSocket} ->
			State =#state{
					listen_socket = ListenSocket
					},
			erlang:send(self() , accept),
			{ok , State};
		{error , Reason} ->
			{stop , Reason}
	end.

%%=================================================================================================%%
%%				gen_server callback functions					   %%
%%=================================================================================================%%

handle_info(accept , State =#state{
					listen_socket = ListenSocket
				}
		) ->
	case gen_tcp:accept(ListenSocket) of
		{ok , Socket} ->
			timer:sleep(1000),
			Pid = test_server_worker:start_link(Socket),
			gen_tcp:controlling_process(Socket , Pid),
			erlang:send(self() , accept),
			{noreply , State};			
		{error , Reason} ->
			{stop , Reason , State}
	end;


handle_info(_Info , State) ->
	{noreply , State}.

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%%

handle_cast(_Cast , State) ->
	{noreply , State}.

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%%

handle_call(_Call , _From , State) ->
	{noreply , State}.

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%%

code_change(_OldVsn , State , _) ->
	{ok , State}.

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%%

terminate(Reason , _State) ->
	{terminate , Reason}.

%%==============================================================================================%%
%%				end of gen_server callback functions				%%
%%==============================================================================================%%


