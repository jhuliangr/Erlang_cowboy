-module(learn_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/hello", learn_http_handler, []}
        ]}
    ]),

    {ok, _} = cowboy:start_clear(http, [
        {port, 3000}
    ], #{
        env => #{dispatch => Dispatch}
    }),

    learn_sup:start_link().

stop(_State) ->
    ok.