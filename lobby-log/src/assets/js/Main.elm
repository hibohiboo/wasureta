port module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onFocus)
import Html.Events.Extra exposing (onChange)
import Html.Keyed as Keyed
import Html.Lazy exposing (..)
import Http
import Json.Decode as D exposing (Value)
import Models.Chat as Chat exposing (Chat)
import Models.ChatView exposing (ChatView)
import Task exposing (Task)
import Url
import Url.Builder
import Utils.HttpUtil as HttpUtil
import Views.ChatView as ChatView


port errorToJs : String -> Cmd msg


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
    , nextToken : String
    }


init : Value -> ( Model, Cmd Msg )
init flags =
    ( Model [] "", Cmd.batch [ Chat.fetchMessages GotMessages "" ] )



-- UPDATE


type Msg
    = GotMessages (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMessages (Ok result) ->
            let
                _ =
                    Debug.log "result" "ここまでOK"
            in
            case D.decodeString Chat.chatsDecoderFromFS result of
                Ok messages ->
                    let
                        _ =
                            Debug.log "テスト" "test"

                        cvMessages =
                            List.map Models.ChatView.fromChat messages

                        _ =
                            Debug.log "cvMessages" cvMessages
                    in
                    ( { model | messages = cvMessages }, Cmd.none )

                Err err ->
                    ( model, D.errorToString err |> errorToJs )

        GotMessages (Err err) ->
            ( model, err |> HttpUtil.httpErrorToString |> errorToJs )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch []


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text "チャットログ" ]
        , lazy chatLogs model.messages
        ]


chatLogs : List ChatView -> Html Msg
chatLogs messages =
    Keyed.node "ul" [ class "collection chatlog" ] (List.map chatMessage messages)


chatMessage : ChatView -> ( String, Html msg )
chatMessage chat =
    let
        key =
            chat.name ++ chat.createdAt
    in
    ( key, ChatView.chatMessage chat.name chat.text chat.createdAt )
