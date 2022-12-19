-module(test_server).


-export([send_data/1]).


-spec send_data(any()) -> ok.
send_data(Data) ->
	BinData = term_to_binary(Data),
	test_server_worker:send_data(BinData).


