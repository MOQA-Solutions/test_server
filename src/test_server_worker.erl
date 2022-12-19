-module(test_server_worker).


-export([start_link/1]).
-export([init/1]).

-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([code_change/3]).
-export([terminate/2]).

-export([send_data/1]).


-include("../include/test_server_worker_data.hrl").


-spec start_link(port()) -> pid().
start_link(Socket) ->
	{ok , Pid} = gen_server:start_link({local , ?MODULE} , ?MODULE , [Socket] , []),
	Pid.


init([Socket]) ->
	State =#state{
			socket = Socket
		},
	{ok , State}.

%%================================================================================================%%
%%				gen_server callback functions					  %%
%%================================================================================================%%

handle_cast({'send data' , Data} , State =#state{
							socket = Socket
					}
		) ->
	gen_tcp:send(Socket , Data),
	{noreply , State};


handle_cast(_Cast , State) ->
	{noreply , State}.

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%%

handle_info({tcp_closed , Socket} , State =#state{
						socket = Socket
					}
		) ->
	{stop , 'connection closed from the client' , State};

handle_info(_Info , State) ->
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

%%================================================================================================%%
%%				end of gen_server callback functions				  %%
%%================================================================================================%%

-spec send_data(term()) -> ok.
send_data(Data) ->
	gen_server:cast(?MODULE , {'send data' , Data}),
	ok.


	
