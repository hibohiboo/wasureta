port module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Events.Extra exposing (onChange)
import Http
import Json.Decode as D exposing (Value)
import Models.Chat as Chat exposing (Chat)
import Models.ChatEditor as ChatEditor exposing (ChatEditor)
import Models.ChatView as ChatView exposing (ChatView)
import Task exposing (Task)
import Time
import Url
import Url.Builder
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
    ( Model [] ChatEditor.init, Cmd.none )


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddChat val ->
            case D.decodeValue ChatView.decoder val of
                Ok chat ->
                    ( { model | messages = chat :: model.messages }, Cmd.none )

                Err a ->
                    ( model, D.errorToString a |> errorToJs )

        InputName val ->
            ( { model | editor = ChatEditor.inputName val model.editor }, Cmd.none )

        InputText val ->
            ( { model | editor = ChatEditor.inputText val model.editor }, Cmd.none )

        SendChat ->
            if model.editor.chat.name == "" || model.editor.chat.text == "" then
                ( model, "名前か本文が空です。送信に失敗しました" |> errorToJs )

            else
                ( model, Task.perform InputCreatedAt timeInMillis )

        InputCreatedAt ms ->
            -- 送信日時を付与して送信。Editorのクリア
            ( { model | editor = ChatEditor.init }, Chat.inputCreatedAt ms model.editor.chat |> Chat.encodeToValue |> sendChat )


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


chatEditor editor =
    chatEditorInputs editor.chat


chatEditorInputs chat =
    div [ class "chat-editor" ]
        [ div [ class "" ]
            [ label [ class "browser-default", for "name" ] [ text "名前" ]
            , input [ class "browser-default", placeholder "名前は必須です", id "name", type_ "text", required True, value chat.name, onChange InputName ] []
            ]
        , div [ class "chat-editor-text" ]
            [ -- label [ class "browser-default", for "name" ] [ text "本文" ],
              input [ class "browser-default", placeholder "本文は必須です", autocomplete False, id "name", type_ "text", required True, value chat.text, onChange InputText ] []
            ]
        , button [ onClick SendChat ] [ text "送信" ]
        ]


chatLogs : List ChatView -> Html Msg
chatLogs messages =
    ul [ class "collection chatlog" ] (List.map chatMessage messages)


chatMessage : ChatView -> Html msg
chatMessage chat =
    ChatView.chatMessage chat.name chat.text chat.createdAt
