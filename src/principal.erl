-module(principal).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, 
    <<"<html><head><title>Pagina Principal</title></head><body><h1>Esta pagina estara en constante mejora segun vaya aprendiendo a usar cowboy</h1></body></html>">>, Req0),
    io:format("/~n",[]),
    {ok, Req, State}.