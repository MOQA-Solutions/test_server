-module(test_server_app).


-behaviour(application).


-export([start/2]).
-export([stop/1]).


-spec start(_Type , _Args) -> {ok , pid()}.
start(_Type , _Args) ->
	{ok , Port} = application:get_env(test_server , port),
	test_server_sup:start_link(Port).


-spec stop(_) -> ok.
stop(_) ->
	ok.



