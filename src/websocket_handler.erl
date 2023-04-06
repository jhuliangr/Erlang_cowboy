-module(websocket_handler).

-export([init/2]).
-export([websocket_handle/2, websocket_info/2, handle/2, terminate/3]).


-record(state, {auth = false}).

init(Req, Opts) ->
    io:format("Iniciado Websocket ~n",[]),
    {cowboy_websocket, Req, Opts,#{ idle_timeout => 30000}}.

websocket_handle(Message, []) ->
    websocket_handle(Message, #state{});

websocket_handle(Message, State=#state{}) ->
    io:format("Mensaje es: ~p y el estado actual es: ~p~n", [Message, State]),
    case Message of
        % {auth, Username, Password} ->
        %     case check_credentials(Username, Password) of
        %         true ->
        %             NewState = State#state{auth=true},
        %             {[{text, "Completada"}], NewState};
        %         false ->
        %             {[{text, "Credenciales incorrectas"}], State}
        %     end;
        {text, <<"jhuliangr, 123">>} ->
            case check_credentials("jhuliangr, 123") of
                true ->
                    NewState = State#state{auth=true},
                    {[{text, "Completada la autenticacion"}], NewState};
                false ->
                    {[{text, "Credenciales incorrectas"}], State}
                end;

        {text, Message0} ->
        case State#state.auth of
            true ->
                io:format("Entro aqui con ~p de message :D", [Message0]),
                websocket_Authenticated_handle({text, Message0}, State);
            false ->
                {[{text, "Autenticacion requerida para continuar"}], State}
        end
    end;
websocket_handle(Param1, State) ->
    io:format("P1: ~p, P2: ~p~n", [Param1, State]),
    {[{text, "No esta haciendo matching con la funcion"}], State}.





websocket_Authenticated_handle({text, <<"close">>}, State) ->
    io:format("Cerrando websocket~n", []),
    {[
        {text, <<"Cerrada la conexion">>},
        {binary, <<0:8000>>},% puedo enviar binary tambien
        {close, 1000, <<"Cerrado por peticion del cliente">>}
    ], State};

websocket_Authenticated_handle(Frame = {text, Txt}, State) ->
    io:format("Handle Llamado, frame es: ~p y state es: ~p~n", [Frame, State]),
    {[{text, <<"Su mensaje ha sido recibido con exito, Este fue: ", Txt/binary>>}], State};
websocket_Authenticated_handle(_Frame, State) ->
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
    




 % function de chequeo
check_credentials(Str) ->
    % case (Username == "123") and (Password == "123") of
    %     true -> true;
    %     false -> false
    % end.
    case Str == "jhuliangr, 123" of
        true -> true;
        false -> false
    end.

