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


port toJs : String -> Cmd msg


port initialize : () -> Cmd msg



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { value : String
    , handouts : List Handout
    , title : String
    , displayNumber : NumberPosition
    }


type NumberPosition
    = LeftNumber
    | RightNumber
    | Hidden


init : String -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.batch [ initialize () ] )



-- 初期化時に、前回の入力を復元する。なければ、サンプルのハンドアウトを入力したものを表示する


initModel : String -> Model
initModel flags =
    if (String.isEmpty flags) then
        { title = "シナリオタイトル", value = initValue, handouts = [ initHandout, initHandout ], displayNumber = Hidden }
    else
        let
            list =
                parse flags
        in
            case list of
                Just a ->
                    { title = "シナリオタイトル", value = flags, handouts = a, displayNumber = Hidden }

                Nothing ->
                    { title = "シナリオタイトル", value = flags, handouts = [], displayNumber = Hidden }


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
    | SwitchTo NumberPosition


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        InputTitle text ->
            ( { model | title = text }, Cmd.none )

        Input text ->
            ( { model | value = text }, toJs text )

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

        SwitchTo pos ->
            ( { model | displayNumber = pos }, Cmd.none )



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
                , p [] [ text "印刷用のハンドアウトが作成できます。「ctrl + p」 で印刷のプレビューを確認できます。" ]
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
            , numberDisplayEdit model
            , button [ onClick HandoutUpdate ] [ text "ハンドアウト更新" ]
            ]
        ]


numberDisplayEdit : Model -> Html Msg
numberDisplayEdit model =
    div [ class "number-display-edit-area" ]
        [ label [] [ text "番号表示" ]
        , radio "左" (model.displayNumber == LeftNumber) (SwitchTo LeftNumber)
        , radio "非表示" (model.displayNumber == Hidden) (SwitchTo Hidden)
        , radio "右" (model.displayNumber == RightNumber) (SwitchTo RightNumber)
        ]


radio : String -> Bool -> msg -> Html msg
radio value isChecked msg =
    label
        []
        [ input [ type_ "radio", name "font-size", onInput (\x -> msg), checked isChecked ] []
        , text value
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
            (handouts model.handouts model.displayNumber)


handouts : List Handout -> NumberPosition -> List (Html Msg)
handouts list pos =
    Array.toList (Array.indexedMap handout (Array.fromList (List.map (\h -> HandoutAndNumberPosition h pos) list)))


type alias HandoutAndNumberPosition =
    { handout : Handout
    , position : NumberPosition
    }


handout : Int -> HandoutAndNumberPosition -> Html Msg
handout i hp =
    let
        h =
            hp.handout

        pos =
            hp.position
    in
        section [ class "handout" ]
            [ div [ class "mission-card handout-card" ]
                [ div [ class "mission-card-head" ]
                    [ div [ class "handout-label" ] [ text "Handout" ]
                    , handoutNumber i (pos == LeftNumber)
                    ]
                , div [ class "handout-card-inner mission-card-inner" ]
                    [ div [ class "mission-title-label" ] [ text "名前" ]
                    , h2 [ class "mission-title" ] [ text h.name ]
                    , div [ class "mission-label" ] [ text "使命" ]
                    , p [ class "mission" ] [ text h.mission ]
                    ]
                ]
            , div [ class "secret-card handout-card" ]
                [ div [ class "secret-card-head" ]
                    [ div [ class "handout-label" ] [ text "Handout" ]
                    , handoutNumber i (pos == RightNumber)
                    ]
                , div [ class "handout-card-inner secret-card-inner" ]
                    [ div [ class "secret-label" ] [ text "秘密" ]
                    , div [ class "shock-label" ] [ text "ショック" ]
                    , div [ class "shock" ] [ text h.shock ]
                    , p [ class "secret" ] [ text h.secret ]
                    , div [ class "secret-caution" ] [ text "この狂気を自分から\n明らかにすることはできない" ]
                    ]
                ]
            ]


handoutNumber : Int -> Bool -> Html Msg
handoutNumber i f =
    if f then
        div [ class "handout-number display" ] [ text <| String.fromInt <| i + 1 ]
    else
        div [ class "handout-number" ] [ text <| String.fromInt <| i + 1 ]



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program String Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
