port module Main exposing (Model, Msg(..), add1, init, main, toJs, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode


-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : Int -> Cmd msg


port initialize : () -> Cmd msg



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { counter : Int
    , serverMessage : String
    }


init : Int -> ( Model, Cmd Msg )
init flags =
    ( { counter = flags, serverMessage = "" }, Cmd.batch [ initialize () ] )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Inc
    | Set Int
    | TestServer
    | OnServerResponse (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Inc ->
            ( add1 model, toJs model.counter )

        Set m ->
            ( { model | counter = m }, toJs model.counter )

        TestServer ->
            let
                expect =
                    Http.expectJson OnServerResponse (Decode.field "result" Decode.string)
            in
                ( model
                , Http.get { url = "/test", expect = expect }
                )

        OnServerResponse res ->
            case res of
                Ok r ->
                    ( { model | serverMessage = r }, Cmd.none )

                Err err ->
                    ( { model | serverMessage = "Error: " ++ httpErrorToString err }, Cmd.none )


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        BadUrl _ ->
            "BadUrl"

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus _ ->
            "BadStatus"

        BadBody s ->
            "BadBody: " ++ s


{-| increments the counter

    add1 5 --> 6

-}
add1 : Model -> Model
add1 model =
    { model | counter = model.counter + 1 }



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ header []
            [ -- img [ src "/images/logo.png" ] []
              span [ class "logo" ] []
            , div [] [ text "ハンドアウトメイカー" ]
            ]
        , article []
            [ h1 []
                [ text "シナリオタイトル" ]
            , time [] [ text "2019/1/1" ]
            , div [ class "handout-list" ]
                [ section [ class "handout" ]
                    [ div [ class "mission-card" ]
                        [ div [ class "mission-card-head" ] [ text "Handout" ]
                        , div [ class "mission-title-label" ] [ text "名前" ]
                        , h2 [ class "mission-title" ] [ text "ハンドアウトタイトル" ]
                        , div [ class "mission-label" ] [ text "使命" ]
                        , p [ class "mission" ] [ text "  校門で君は気づいた。\n外に出られない。赤い赤い夕焼け空。長い長い黒い影。誰もいないグラウンド。音のしない校舎。風のない蒸し暑い空気。時計は 4 時 44 分 44 秒.校門に集まっているやつらの誰も、帰り方を知らない。君も分からない。君の使命は【家に帰る】ことである。" ]
                        ]
                    , div [ class "secret-card" ]
                        [ div [ class "secret-label" ] [ text "秘密" ]
                        , div [ class "shock-label" ] [ text "ショック" ]
                        , div [ class "shock" ] [ text "PC１" ]
                        , p [ class "secret" ] [ text "校門で君は気づいた。\n外に出られない。赤い赤い夕焼け空。長い長い黒い影。誰もいないグラウンド。音のしない校舎。風のない蒸し暑い空気。時計は 4 時 44 分 44 秒.校門に集まっているやつらの誰も、帰り方を知らない。君も分からない。君の使命は【家に帰る】ことである。" ]
                        ]
                    ]
                ]
            ]
        ]



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program Int Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
