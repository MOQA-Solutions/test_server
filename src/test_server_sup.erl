-module(test_server_sup).


-export([start_link/1]).
-export([init/1]).


-spec start_link(pos_integer()) -> {ok , pid()}.
start_link(Port) ->
	supervisor:start_link(?MODULE , [Port]).


init([Port]) ->
	SupFlags =#{
		strategy => one_for_one,
		intensity => 1,
		period => 5
		},

	ChildSpecs =#{
		id => testserverlistener,
		start => {test_server_listener , start_link , [Port]},
		restart => permanent,
		shutdown => brutal_kill,
		type => supervisor,
		modules => [test_server_listener]
		},

	Children = [ChildSpecs],

	{ok , {SupFlags , Children}}.



