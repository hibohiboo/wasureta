port module Main exposing (main)

{-| This demonstrates laying out the characters in Les Miserables
based on their co-occurence in a scene. Try dragging the nodes!
-}

import Browser
import Browser.Events
import ForceDirectedGraph exposing (update, init, subscriptions, Msg(..), Model, forceGraph, EditMode(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import InfoParser exposing (Info)
import BackCanvas exposing (backCanvas, getPointCircleLine)
import Canvas exposing (toHtml)


-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "情報項目グラフ化ツール" ]
        , editArea model
        , button [ onClick NewInfo ] [ text "項目追加" ]
        , updateButton model
        , button [ id "save" ] [ text "画像ダウンロード" ]
        , div []
            [ span [] [ text "サンプルデータは" ]
            , a [ href "http://transmitter.seesaa.net/article/460919085.html" ] [ text "トーキョーN◎VA 自作シナリオ入門書" ]
            , span [] [ text "を参考にさせていただきました。" ]
            ]
        , forceGraph model
        ]


updateButton model =
    if model.editMode == TextEditMode then
        button [ onClick InformationsUpdate ] [ text "画像に反映" ]
    else
        span [] [ text "リンク編集モード" ]


editArea : Model -> Html Msg
editArea model =
    let
        navTextClass =
            if model.editMode == TextEditMode then
                "selected"
            else
                ""

        navLinkClass =
            if model.editMode == LinkEditMode then
                "selected"
            else
                ""

        edit =
            if model.editMode == TextEditMode then
                textEditArea model
            else
                linkEditArea model
    in
        div [ class "editor" ]
            [ nav [ class "tabs" ]
                [ a [ class navTextClass, onClick ChangeTextEditMode ] [ text "情報入力" ]
                , a [ class navLinkClass, onClick ChangeLinkEditMode ] [ text "リンク作成" ]
                ]
            , edit
            ]


textEditArea model =
    div [ class "editor-main" ]
        [ div
            []
            [ label [ for "editor" ] [ text "シナリオプロット" ]
            , br [] []
            , textarea
                [ id "editor"
                , onInput Input
                ]
                [ text model.value ]
            ]
        , p [] [ text "色は次の中から選べます。 [black, white, red, blue, green, yellow, purple, gray, brown]" ]
        ]


linkEditArea model =
    let
        itemNum =
            List.length model.informations

        deg =
            360 / toFloat itemNum

        rad =
            deg * pi / 180

        r =
            300

        width =
            700

        height =
            700
    in
        div [ class "editor-main" ]
            [ div [] [ text "2つの番号をクリックすると線をつなぎます。" ]
            , div []
                [ Canvas.toHtml ( width, height )
                    [ class "editor-canvas" ]
                    (backCanvas width height rad r model.informations)
                , div [ class "link-edit-area" ]
                    (Array.toList <| Array.indexedMap (\i info -> linkInfoItem i info rad r model.selectedNode) <| Array.fromList model.informations)
                ]
            ]


linkInfoItem : Int -> Info -> Float -> Float -> Maybe Int -> Html Msg
linkInfoItem i info rad r selectedNum =
    let
        ( x, y ) =
            getPointCircleLine i rad r

        leftX =
            (String.fromFloat x) ++ "px"

        topY =
            (String.fromFloat y) ++ "px"

        selectedClass =
            case selectedNum of
                Just a ->
                    if a == i then
                        "selected"
                    else
                        ""

                Nothing ->
                    ""
    in
        div
            [ class "item"
            , class selectedClass
            , style "left" leftX
            , style "top" topY
            , onClick (ClickLinkNode i)
            ]
            [ span [ class "circle" ] [ text <| String.fromInt i ]
            , span [ class "item-label" ] [ text info.title ]
            , span [ class "item-links" ] [ text (String.join "," <| List.map String.fromInt info.list) ]
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input text ->
            ( ForceDirectedGraph.update msg model, toJs text )

        ClickLinkNode i ->
            ( ForceDirectedGraph.update msg model, toJs model.value )

        ChangeTextEditMode ->
            ( ForceDirectedGraph.update msg model, toJs model.value )

        _ ->
            ( ForceDirectedGraph.update msg model, Cmd.none )


main : Program String Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



{- {"delay": 5001} -}
