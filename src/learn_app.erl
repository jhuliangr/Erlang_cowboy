-module(learn_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

-define(NO_OPTIONS, []).
-define(CUALQUIER_HOST,'_').

start(_StartType, _StartArgs) ->
%    Constraints = [{an_int, int},
%                    {three_chars, function, fun three_chars/1},
%                    {add_one, function, fun add_one/1}%,
%                    %{non_empty, nonempty}, %% not_implemented in this version
%                   ],

    Paths = [
        {"/hello", learn_http_handler, ?NO_OPTIONS}, 
         {"/websocket", websocket_handler, ?NO_OPTIONS},
         {"/", cowboy_static, {priv_file, learn, "static/main.html"}}, % servir archivos html
         {"/[...]", cowboy_static, {priv_dir, learn, "static"}} % servir todo lo que este en la carpeta priv/static
        %  {"/form", form_handler, ?NO_OPTIONS},
        %  {"/chunked_form", chunked_handler, ?NO_OPTIONS},
        %  {"/constraints/:anything", constraints_handler, {constraints_met, true}},
        %  {"/constraints/:an_int/:three_chars/[:add_one]", Constraints, constraints_handler, {constraints_met, true}},
        %  {"/constraints/[...]", constraints_handler, {constraints_met, false}},
        %  {"/animate", animate_ws_handler, ?NO_OPTIONS},
    ],

    Routes = [{?CUALQUIER_HOST, Paths},
              {"[...]", [{"/hpi/[...]", host_path_info_handler, ?NO_OPTIONS}]}],

    Dispatch = cowboy_router:compile(
        % [
        %     {'_', [
        %         {"/hello", learn_http_handler, []},
        %         {"/",principal, []}
        %     ]}
        % ]
        Routes
    ),
        _ = cowboy:start_clear(http, 
            [{port, 3000}], 
        #{env => #{dispatch => Dispatch}}
    ),
    learn_sup:start_link().

stop(_State) ->
    ok.