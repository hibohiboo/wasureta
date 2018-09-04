module Main exposing (..)

import Browser exposing (..)
import Html exposing(..)

-- モデル


type alias Model =
    String


init : Int -> ( Model, Cmd Msg )
init flag =
    ( "Hello", Cmd.none )



-- メッセージ


type Msg
    = NoOp



-- ビュー


view : Model -> Html Msg
view model =
    div []
        [ text model ]



-- 更新


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- サブスクリプション(購読)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Int Model Msg
main =
    element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }