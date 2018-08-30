port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Value, Decoder, decodeString, field, string)
import Json.Decode.Pipeline exposing (decode, required)
import Html.Events exposing (..)


port logout : () -> Cmd msg


type alias User =
    { uid : String
    , displayName : String
    }


decoder : Decoder User
decoder =
    decode User
        |> Json.Decode.Pipeline.required "uid" Decode.string
        |> Json.Decode.Pipeline.required "displayName" Decode.string


decodeUserFromJson : Value -> Maybe User
decodeUserFromJson json =
    -- let
    -- _ =
    --     Debug.log "decodeUser" json
    -- in
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString decoder >> Result.toMaybe)



-- モデル


type alias Model =
    { user : Maybe User }


init : Value -> ( Model, Cmd Msg )
init val =
    ( { user = decodeUserFromJson val }, Cmd.none )



-- メッセージ


type Msg
    = NoOp
    | Logout



-- ビュー


view : Model -> Html Msg
view model =
    let
        user =
            model.user

        -- _ =
        --     Debug.log "user" model
    in
        case user of
            Nothing ->
                span []
                    [ a [ href "./sign-in.html" ]
                        [ text "ログイン" ]
                    ]

            Just user ->
                span []
                    [ a [ onClick Logout ]
                        [ text "ログアウト" ]
                    ]



-- 更新


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Logout ->
            ( { model | user = Nothing }, Cmd.batch [ logout () ] )



-- サブスクリプション(購読)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
