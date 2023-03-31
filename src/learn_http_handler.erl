-module(learn_http_handler).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    {ok, Req2} = cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain; charset=utf-8">>}, <<"Hola Mundo">>, Req),
    {ok, Req2, State}.