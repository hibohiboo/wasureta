port module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onFocus)
import Html.Events.Extra exposing (onChange)
import Http
import Json.Decode as D exposing (Value)
import Models.Chat as Chat exposing (Chat)
import Models.ChatEditor as ChatEditor exposing (ChatEditor)
import Models.ChatView as ChatView exposing (ChatView)
import Models.DiceBotApi as DiceBotApi
import Task exposing (Task)
import Time
import Url
import Url.Builder
import Utils.HttpUtil as HttpUtil
import Views.ChatView as ChatView


port errorToJs : String -> Cmd msg


port addChat : (Value -> msg) -> Sub msg


port sendChat : Value -> Cmd msg


main : Program Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { messages : List ChatView
    , editor : ChatEditor
    }


init : Value -> ( Model, Cmd Msg )
init flags =
    ( Model [] ChatEditor.init, Cmd.batch [ DiceBotApi.fetchSystemNames GotSystems ] )


timeInMillis : Task x Int
timeInMillis =
    Time.now
        |> Task.andThen (\t -> Task.succeed (Time.posixToMillis t))



-- UPDATE


type Msg
    = AddChat Value
    | InputName String
    | InputText String
    | SendChat
    | InputCreatedAt Int
    | GotDiceRoll (Result Http.Error String)
    | DiceRoll
    | InputFace String
    | InputDiceCommand String
    | InputDiceNumber String
    | GotSystems (Result Http.Error String)
    | InputSelectedSystem String
    | FocusDiceFace


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddChat val ->
            case D.decodeValue ChatView.decoder val of
                Ok chat ->
                    ( { model | messages = chat :: model.messages }, Cmd.none )

                Err err ->
                    ( model, D.errorToString err |> errorToJs )

        InputName val ->
            ( { model | editor = ChatEditor.inputName val model.editor }, Cmd.none )

        InputText val ->
            ( { model | editor = ChatEditor.inputText val model.editor }, Cmd.none )

        InputFace val ->
            ( { model | editor = ChatEditor.inputFace val model.editor }, Cmd.none )

        FocusDiceFace ->
            ( { model | editor = ChatEditor.inputFace "0" model.editor }, Cmd.none )

        InputDiceNumber val ->
            ( { model | editor = ChatEditor.inputDiceNumber val model.editor }, Cmd.none )

        InputDiceCommand val ->
            ( { model | editor = ChatEditor.inputDiceCommand val model.editor }, Cmd.none )

        InputSelectedSystem val ->
            ( { model | editor = ChatEditor.inputSelectedSystemName val model.editor }, Cmd.none )

        SendChat ->
            if model.editor.chat.name == "" then
                ( model, "名前が空です。送信に失敗しました" |> errorToJs )

            else if model.editor.chat.text == "" then
                ( model, "本文が空です。送信に失敗しました" |> errorToJs )

            else
                ( model, Task.perform InputCreatedAt timeInMillis )

        InputCreatedAt ms ->
            -- 送信日時を付与して送信。Editorのクリア
            ( { model | editor = ChatEditor.inputText "" model.editor }, Chat.inputCreatedAt ms model.editor.chat |> Chat.encodeToValue |> sendChat )

        GotDiceRoll (Ok result) ->
            update SendChat { model | editor = model.editor |> ChatEditor.inputText (model.editor.chat.text ++ " | " ++ result) }

        GotDiceRoll (Err err) ->
            ( model, err |> HttpUtil.httpErrorToString |> errorToJs )

        DiceRoll ->
            let
                editor =
                    model.editor

                command =
                    String.fromInt editor.diceNumber ++ "d" ++ String.fromInt editor.diceFace ++ editor.diceCommand

                newModel =
                    if model.editor.chat.name == "" then
                        { model | editor = ChatEditor.inputName model.editor.selectedSystemName model.editor }

                    else
                        model
            in
            ( newModel, DiceBotApi.fetchDiceRollResult GotDiceRoll model.editor.selectedSystemName command )

        GotSystems (Ok result) ->
            case D.decodeString DiceBotApi.namesDecoder result of
                Ok names ->
                    ( { model | editor = ChatEditor.inputNames names model.editor }, Cmd.none )

                Err err ->
                    ( model, D.errorToString err |> errorToJs )

        GotSystems (Err err) ->
            ( model, err |> HttpUtil.httpErrorToString |> errorToJs )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ addChat AddChat ]


view : Model -> Html Msg
view model =
    div []
        [ chatEditor model.editor
        , p [ style "font-size" "1.2rem" ] [ text "新着メッセージ" ]
        , chatLogs model.messages
        ]


chatEditor : ChatEditor -> Html Msg
chatEditor editor =
    chatEditorInputs editor


chatEditorInputs : ChatEditor -> Html Msg
chatEditorInputs editor =
    let
        chat =
            editor.chat
    in
    div [ class "chat-editor" ]
        [ div [ class "" ]
            [ label [ class "browser-default", for "name" ] [ text "名前" ]
            , input [ class "browser-default", placeholder "名前は必須です", id "name", type_ "text", required True, value chat.name, onChange InputName ] []
            ]
        , div [ class "chat-editor-text" ]
            [ -- label [ class "browser-default", for "name" ] [ text "本文" ],
              input [ class "browser-default", placeholder "本文は必須です", autocomplete False, id "name", type_ "text", required True, value chat.text, onChange InputText ] []
            ]
        , div [ class "send-wrapper" ]
            [ button [ onClick SendChat ] [ text "送信" ]
            , select [ id "dicebot", class "browser-default" ] (editor.names |> List.map (\names_ -> option [ class "browser-default", value names_.system, selected (editor.selectedSystemName == names_.system) ] [ text names_.name ]))
            , input [ class "browser-default", autocomplete False, id "dice-number", type_ "number", value (String.fromInt editor.diceNumber), onChange InputDiceNumber ] []
            , select [ class "browser-default", disabled True ] [ option [ value "", class "browser-default", selected True ] [ text "D" ] ]
            , input [ class "browser-default", autocomplete True, id "face", list "face-list", type_ "number", value (ChatEditor.toStringDiceFace editor.diceFace), onChange InputFace, onFocus FocusDiceFace ] []
            , input [ class "browser-default", autocomplete False, id "dice-command", type_ "text", value editor.diceCommand, onChange InputDiceCommand ] []
            , button [ onClick DiceRoll ] [ text "ダイスを振る" ]
            ]
        , datalist [ id "face-list" ] (List.map (\s -> option [ value (String.fromInt s) ] [ text (String.fromInt s) ]) [ 2, 4, 6, 8, 12, 20, 100 ])
        ]


chatLogs : List ChatView -> Html Msg
chatLogs messages =
    ul [ class "collection chatlog" ] (List.map chatMessage messages)


chatMessage : ChatView -> Html msg
chatMessage chat =
    ChatView.chatMessage chat.name chat.text chat.createdAt
