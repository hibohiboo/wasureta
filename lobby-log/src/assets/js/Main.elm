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
import Time exposing (Zone)
import Url
import Url.Builder
import Utils.FirestoreApi as FS
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
    , zone : Zone
    }


init : Value -> ( Model, Cmd Msg )
init flags =
    ( Model [] "" Time.utc, Cmd.batch [ Task.perform AdjustTimeZone Time.here ] )



-- UPDATE


type Msg
    = GotMessages (Result Http.Error String)
    | AdjustTimeZone Zone
    | NextPage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AdjustTimeZone zone ->
            ( { model | zone = zone }, Cmd.batch [ Chat.fetchMessages GotMessages "" ] )

        GotMessages (Ok result) ->
            -- let
            --     _ =
            --         Debug.log "result" result
            -- in
            case D.decodeString Chat.chatsDecoderFromFS result of
                Ok messages ->
                    let
                        cvMessages =
                            List.map (\m -> Models.ChatView.fromChat model.zone m) messages

                        token =
                            FS.nextTokenFromJson result
                    in
                    ( { model | messages = List.concat [ model.messages, cvMessages ], nextToken = token }, Cmd.none )

                Err err ->
                    ( model, D.errorToString err |> errorToJs )

        GotMessages (Err err) ->
            ( model, err |> HttpUtil.httpErrorToString |> errorToJs )

        NextPage ->
            ( model, Cmd.batch [ Chat.fetchMessages GotMessages model.nextToken ] )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch []


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text "チャットログ" ]
        , lazy chatLogs model.messages
        , lazy nextPage model
        ]


nextPage model =
    if model.nextToken == "last" then
        span [] [ text "" ]

    else
        button [ onClick NextPage ] [ text "さらに読み込む" ]


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
