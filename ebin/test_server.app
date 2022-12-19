{application , 'test_server' , 

 [

	{description , "coding challenge server side"},

	{vsn , "0.1"},

	{modules , ['test_server' , 'test_server_app' , 'test_server_sup' , 'test_server_listener' , 'test_server_worker']},

	{applications , [kernel , stdlib]},

	{mod , {test_server_app , []}},

	{env , [

		{port , 10}

	       ]

	}

 ]

}.


	
