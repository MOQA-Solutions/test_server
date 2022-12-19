-record(state , {

	listen_socket :: port()

	}

).

-define(SOCKOPTS , [

			binary,

			{active , true},

			{packet , 4},

			{backlog , 1024},

			{nodelay , true}

		]

).



