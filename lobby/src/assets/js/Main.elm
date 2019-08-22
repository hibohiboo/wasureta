port module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as D exposing (Value)
import Models.Chat as Chat exposing (Chat)
import Url
import Url.Builder
import Views.ChatView as ChatView


port errorToJs : String -> Cmd msg


port addChat : (Value -> msg) -> Sub msg


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
    { messages : List Chat
    }


init : Value -> ( Model, Cmd Msg )
init flags =
    ( Model [], Cmd.none )



-- UPDATE


type Msg
    = AddChat Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddChat val ->
            case D.decodeValue Chat.decoder val of
                Ok chat ->
                    ( { model | messages = chat :: model.messages }, Cmd.none )

                Err a ->
                    ( model, errorToJs <| D.errorToString a )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ addChat AddChat ]


view : Model -> Html Msg
view model =
    ul [ class "collection chatlog" ] (List.map chatMessage model.messages)


chatMessage : Chat -> Html msg
chatMessage chat =
    ChatView.chatMessage chat.name chat.text chat.createdAt
