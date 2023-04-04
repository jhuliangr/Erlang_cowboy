-module(learn_http_handler).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, 
    <<"<html><head><title>Hello Maifren</title></head><body><h1>Hola Mundo</h1></body></html>">>, Req0),
    io:format("/hello~n",[]),
    {ok, Req, State}.