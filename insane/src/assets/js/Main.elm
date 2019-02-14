port module Main exposing (Model, Msg(..), init, main, toJs, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import HandoutParser exposing (parse, Handout)
import Array


-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : Int -> Cmd msg


port initialize : () -> Cmd msg



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { value : String
    , handouts : List Handout
    , title : String
    }


init : Int -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.batch [ initialize () ] )


initModel : Int -> Model
initModel flags =
    { title = "シナリオタイトル", value = initValue, handouts = [ initHandout, initHandout ] }


initValue : String
initValue =
    (handoutToString initHandout) ++ (handoutToString initHandout)


handoutToString : Handout -> String
handoutToString h =
    "[ハンドアウト名]["
        ++ h.name
        ++ "]"
        ++ "\n[使命]["
        ++ h.mission
        ++ "]"
        ++ "\n[ショック]["
        ++ h.shock
        ++ "]"
        ++ "\n[秘密]["
        ++ h.secret
        ++ "]"
        ++ "\n----"
        ++ "\n"


initHandout : Handout
initHandout =
    Handout "PC1" "校門で君は気づいた。\n外に出られない。赤い赤い夕焼け空。長い長い黒い影。誰もいないグラウンド。音のしない校舎。風のない蒸し暑い空気。時計は 4 時 44 分 44 秒.校門に集まっているやつらの誰も、帰り方を知らない。君も分からない。君の使命は【家に帰る】ことである。" "なし" "秘密を見てはならない"



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Input String
    | InputTitle String
    | HandoutUpdate


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        InputTitle text ->
            ( { model | title = text }, Cmd.none )

        Input text ->
            ( { model | value = text }, Cmd.none )

        HandoutUpdate ->
            let
                list =
                    parse model.value
            in
                case list of
                    Just a ->
                        ( { model | handouts = a }, Cmd.none )

                    Nothing ->
                        ( { model | handouts = [] }, Cmd.none )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ header []
            [ -- img [ src "/images/logo.png" ] []
              -- span [ class "logo" ] []
              -- ,
              div []
                [ h1 [] [ text "ハンドアウトメイカー" ]
                , p [] [ text "印刷用のハンドアウトが作成できます。" ]
                , p [] [ text "フォーマットに従ってテキストを入力し、「ハンドアウト更新」のボタンを押してください。" ]
                ]
            ]
        , editArea model
        , article []
            [ -- h1 [] [ text model.title ]
              -- , time [] [ text "2019/1/1" ]
              -- ,
              handoutArea model
            ]
        ]


editArea : Model -> Html Msg
editArea model =
    div [ class "editor" ]
        [ -- label []
          -- [ text "タイトル"
          -- , input
          --     [ id "title"
          --     , onInput InputTitle
          --     , value model.title
          --     ]
          --     []
          -- ]
          -- ,
          div []
            [ label [ for "editor" ] [ text "ハンドアウト" ]
            , textarea
                [ id "editor"
                , onInput Input
                ]
                [ text model.value ]
            , button [ onClick HandoutUpdate ] [ text "ハンドアウト更新" ]
            ]
        ]



-- ---------------------------
-- ハンドアウト
-- ---------------------------


handoutArea model =
    if (List.length model.handouts) == 0 then
        div [ class "handout-guide" ]
            [ span [ class "caution" ] [ text "ハンドアウトの入力フォーマットが異なります。" ]
            , br [] []
            , text "以下の形式でハンドアウトを入力してください。"
            , br [] []
            , div [ class "pre" ] [ text "[ハンドアウト名][〇〇]\n[使命][〇〇]\n[ショック][〇〇]\n[秘密][〇〇]\n----\n" ]
            , span [ class "caution" ] [ text "※注意： 最後の----までがフォーマットです。入力を間違えると表示できません。" ]
            ]
    else
        div [ class "handout-list" ]
            (handouts model.handouts)


handouts : List Handout -> List (Html Msg)
handouts list =
    Array.toList (Array.indexedMap handout (Array.fromList list))


handout : Int -> Handout -> Html Msg
handout i h =
    section [ class "handout" ]
        [ div [ class "mission-card handout-card" ]
            [ div [ class "mission-card-head" ] [ text "Handout" ]
            , div [ class "handout-card-inner mission-card-inner" ]
                [ div [ class "mission-title-label" ] [ text "名前" ]
                , h2 [ class "mission-title" ] [ text h.name ]
                , div [ class "mission-label" ] [ text "使命" ]
                , p [ class "mission" ] [ text h.mission ]
                ]
            ]
        , div [ class "secret-card handout-card" ]
            [ div [ class "secret-card-head" ] [ text "Handout" ]
            , div [ class "handout-card-inner secret-card-inner" ]
                [ div [ class "secret-label" ] [ text "秘密" ]
                , div [ class "shock-label" ] [ text "ショック" ]
                , div [ class "shock" ] [ text h.shock ]
                , p [ class "secret" ] [ text h.secret ]
                , div [ class "secret-caution" ] [ text "この狂気を自分から\n明らかにすることはできない" ]
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
