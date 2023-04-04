-module(websocket_handler).

-export([init/2]).
-export([websocket_init/2, websocket_handle/2, websocket_info/2, handle/2, terminate/3]).


-record(state, {}).

init(Req, Opts) ->
    io:format("Iniciado Websocket~n",[]),
    {cowboy_websocket, Req, Opts,#{ idle_timeout => 30000}}.

websocket_init(Req0, State) ->
    io:format("se llamo a la websocket init esta~n"),
    case cowboy_req:parse_header(<<"sec-websocket-protocol">>, Req0) of
        undefined ->
            {cowboy_websocket, Req0, State};
        Subprotocols ->
            case lists:keymember(<<"mqtt">>, 1, Subprotocols) of
                true ->
                    Req = cowboy_req:set_resp_header(<<"sec-websocket-protocol">>,
                        <<"mqtt">>, Req0),
                    {cowboy_websocket, Req, State};
                false ->
                    Req = cowboy_req:reply(400, Req0),
                    {ok, Req, State}
            end
    end.

websocket_handle({text, <<"close">>}, State) ->
    io:format("Cerrando websocket~n", []),
    {[
        {text, <<"Cerrada la conexion">>},
        {binary, <<0:8000>>},% puedo enviar binary tambien
        {close, 1000, <<"Cerrado por peticion del cliente">>}
    ], State};

websocket_handle(Frame = {text, Txt}, State) ->
    io:format("Handle Llamado, frame es: ~p y state es: ~p~n", [Frame, State]),
    {[{text, <<"Su mensaje ha sido recibido con exito, Este fue: ", Txt/binary>>}], State};
websocket_handle(_Frame, State) ->
    {ok, State}.

websocket_info({log, Text}, State) ->
    io:format("Info Llamado"),
    {[{text, Text}], State};

websocket_info(_Info, State) ->
    {ok, State}.

handle(Req, State= #state{}) ->
    {ok, Req, State}.

terminate(_Reason, _Req, State) ->
    {stop, State}.
    
