module ForceDirectedGraph exposing (init, update, forceGraph, Msg(..), Model, subscriptions)

{-| This demonstrates laying out the characters in Les Miserables
based on their co-occurence in a scene. Try dragging the nodes!
-}

import Browser
import Browser.Events
import Color
import Force exposing (State)
import Graph exposing (Edge, Graph, Node, NodeContext, NodeId)
import Html exposing (div)
import Html.Events exposing (on)
import Html.Events.Extra.Mouse as Mouse
import Json.Decode as Decode
import SampleData exposing (miserablesGraph)
import Time
import Svg exposing (foreignObject)
import TypedSvg exposing (circle, g, line, svg, title, text_, rect)
import TypedSvg.Attributes exposing (class, fill, stroke, viewBox)
import TypedSvg.Attributes.InPx exposing (cx, cy, r, strokeWidth, x1, x2, y1, y2, x, y, height, width, fontSize)
import TypedSvg.Core exposing (Attribute, Svg, text)
import TypedSvg.Types exposing (Fill(..))
import Array
import InfoToData exposing (toData)
import InfoParser exposing (parse, Info)


w : Float
w =
    1290


h : Float
h =
    2004


type Msg
    = DragStart NodeId ( Float, Float )
    | DragAt ( Float, Float )
    | DragEnd ( Float, Float )
    | Tick Time.Posix
    | Input String
    | InformationsUpdate


type alias Model =
    { drag : Maybe Drag
    , graph : Graph Entity ()
    , simulation : Force.State NodeId
    , value : String
    , informations : List Info
    }


type alias Drag =
    { start : ( Float, Float )
    , current : ( Float, Float )
    , index : NodeId
    }


type alias Entity =
    Force.Entity NodeId { value : String }


initializeNode : NodeContext String () -> NodeContext Entity ()
initializeNode ctx =
    { node = { label = Force.entity ctx.node.id ctx.node.label, id = ctx.node.id }
    , incoming = ctx.incoming
    , outgoing = ctx.outgoing
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        link { from, to } =
            { source = from
            , target = to
            , distance = 150
            , strength = Just 0.605
            }

        forces =
            [ Force.customLinks 0 <| List.map link <| Graph.edges graph
            , Force.manyBody <| List.map .id <| Graph.nodes graph
            , Force.manyBodyStrength -150 <| List.map .id <| Graph.nodes graph
            , Force.center (w / 2) (h / 2 - 300)
            ]

        informations =
            [ InfoParser.Info "オープニング" "開始" [ 1, 2, 3 ] -- 0
            , InfoParser.Info "PC1" "ヒロインと出会う" [ 4, 16 ] -- 1
            , InfoParser.Info "PC2" "ボスとの因縁" [ 5 ] -- 2
            , InfoParser.Info "PC3" "事件を追う" [ 6, 7 ] -- 3
            , InfoParser.Info "【情報1】" "ヒロインについて" [ 8 ] -- 4
            , InfoParser.Info "【情報2】" "ボスについて" [ 17 ] -- 5
            , InfoParser.Info "【情報3】" "事件について" [ 9, 10 ] -- 6
            , InfoParser.Info "【情報4】" "アイテムについて" [ 9 ] -- 7
            , InfoParser.Info "【情報5】" "ヒロイン性" [ 11 ] -- 8
            , InfoParser.Info "【情報6】" "事件・アイテムの裏" [ 18 ] -- 9
            , InfoParser.Info "【情報7】" "裏ボスについて" [ 13, 18 ] -- 10
            , InfoParser.Info "【情報8】" "ヒロインの過去" [ 19 ] -- 11
            , InfoParser.Info "【情報9】" "ボスの経歴" [ 14 ] -- 12
            , InfoParser.Info "【情報10】" "裏ボスの経歴" [ 14 ] -- 13
            , InfoParser.Info "【情報11】" "ボスたちの行動と結果予測" [ 15 ] -- 14
            , InfoParser.Info "【情報12】" "クライマックスへの到達方法" [ 20 ] -- 15
            , InfoParser.Info "【イベント】PC1" "ボスがヒロインを狙う" [ 11 ] -- 16
            , InfoParser.Info "【イベント】PC2" "ボスが警告" [ 12 ] -- 17
            , InfoParser.Info "【イベント】PC3" "上司からの発破" [] -- 18
            , InfoParser.Info "【イベント】PC1" "ヒロインからの問いかけ" [ 14 ] -- 19
            , InfoParser.Info "【マスターシーン】" "クライマックス前演出" [ 21 ] -- 20
            , InfoParser.Info "【クライマックス】" "前口上・クライマックス戦闘" [ 22 ] -- 21
            , InfoParser.Info "【エンディング】" "ふたりは幸せなキスをして終了" [] -- 22
            ]

        graph =
            Graph.mapContexts initializeNode (toData informations)

        value =
            Array.fromList informations
                |> Array.indexedMap (\i info -> infoToString i info)
                |> Array.toList
                |> String.join "\n"

        simulation =
            (Force.simulation forces)
    in
        ( Model Nothing graph simulation value informations, Cmd.none )


infoToString : Int -> Info -> String
infoToString i info =
    "// "
        ++ String.fromInt i
        ++ "\n[タイトル]["
        ++ info.title
        ++ "]"
        ++ "\n[情報]["
        ++ info.info
        ++ "]"
        ++ "\n[リンク先]["
        ++ (String.join "," <| List.map (\n -> String.fromInt n) info.list)
        ++ "]"
        ++ "\n----\n"


updateNode : ( Float, Float ) -> NodeContext Entity () -> NodeContext Entity ()
updateNode ( x, y ) nodeCtx =
    let
        nodeValue =
            nodeCtx.node.label
    in
        updateContextWithValue nodeCtx { nodeValue | x = x, y = y }


updateContextWithValue : NodeContext Entity () -> Entity -> NodeContext Entity ()
updateContextWithValue nodeCtx value =
    let
        node =
            nodeCtx.node
    in
        { nodeCtx | node = { node | label = value } }


updateGraphWithList : Graph Entity () -> List Entity -> Graph Entity ()
updateGraphWithList =
    let
        graphUpdater value =
            Maybe.map (\ctx -> updateContextWithValue ctx value)
    in
        List.foldr (\node graph -> Graph.update node.id (graphUpdater node) graph)


update : Msg -> Model -> Model
update msg ({ drag, graph, simulation, value, informations } as model) =
    case msg of
        Tick t ->
            let
                ( newState, list ) =
                    Force.tick simulation <| List.map .label <| Graph.nodes graph
            in
                case drag of
                    Nothing ->
                        Model drag (updateGraphWithList graph list) newState value informations

                    Just { current, index } ->
                        Model drag
                            (Graph.update index
                                (Maybe.map (updateNode current))
                                (updateGraphWithList graph list)
                            )
                            newState
                            value
                            informations

        DragStart index xy ->
            Model (Just (Drag xy xy index)) graph simulation value informations

        DragAt xy ->
            let
                ( posX, posY ) =
                    xy
            in
                case drag of
                    Just { start, index } ->
                        Model (Just (Drag start xy index))
                            (Graph.update index (Maybe.map (updateNode xy)) graph)
                            (Force.reheat simulation)
                            value
                            informations

                    Nothing ->
                        Model Nothing graph simulation value informations

        DragEnd xy ->
            case drag of
                Just { start, index } ->
                    Model Nothing
                        (Graph.update index (Maybe.map (updateNode xy)) graph)
                        simulation
                        value
                        informations

                Nothing ->
                    Model Nothing graph simulation value informations

        Input text ->
            { model | value = text }

        InformationsUpdate ->
            let
                list =
                    parse value
            in
                case list of
                    Just a ->
                        let
                            gr =
                                Graph.mapContexts initializeNode (toData a)
                        in
                            Model Nothing gr (Force.reheat simulation) value a

                    Nothing ->
                        { model | informations = [] }


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            -- This allows us to save resources, as if the simulation is done, there is no point in subscribing
            -- to the rAF.
            if Force.isCompleted model.simulation then
                Sub.none
            else
                Browser.Events.onAnimationFrame Tick

        Just _ ->
            Sub.batch
                [ Browser.Events.onMouseMove (Decode.map (.clientPos >> DragAt) Mouse.eventDecoder)
                , Browser.Events.onMouseUp (Decode.map (.clientPos >> DragEnd) Mouse.eventDecoder)
                , Browser.Events.onAnimationFrame Tick
                ]


onMouseDown : NodeId -> Attribute Msg
onMouseDown index =
    Mouse.onDown (.clientPos >> DragStart index)


linkElement graph edge =
    let
        source =
            Maybe.withDefault (Force.entity 0 "") <| Maybe.map (.node >> .label) <| Graph.get edge.from graph

        target =
            Maybe.withDefault (Force.entity 0 "") <| Maybe.map (.node >> .label) <| Graph.get edge.to graph
    in
        line
            [ strokeWidth 2
            , stroke (Color.rgb255 170 170 170)
            , x1 source.x
            , y1 source.y
            , x2 target.x
            , y2 target.y
            ]
            []



-- タイトルのフォントサイズ (px) css参照


titleSizeNum =
    14



-- フォントサイズ (px) css参照


fontSizeNum =
    12



-- -- 1行の文字数
-- maxTextLength =
--     14
-- 線の太さ


strokeWidthNum =
    3


nodeElement node informations =
    let
        info =
            case (Array.get node.id informations) of
                Just a ->
                    a

                Nothing ->
                    Info "" "" []

        titleText =
            info.title

        dispText =
            info.info

        --1行ずつ分割する
        texts =
            Array.fromList (String.lines dispText)

        -- 改行の数
        newLineCount =
            Array.length texts

        -- 1行の最大文字数
        maxTextLength =
            let
                max =
                    Array.map (\s -> String.length s) texts |> Array.toList |> List.maximum
            in
                case max of
                    Just m ->
                        m

                    Nothing ->
                        0

        -- 左パディング＋文字の大きさ*文字の長さ＋右パディング
        wid =
            let
                titleLength =
                    String.length titleText
            in
                if maxTextLength > titleLength then
                    fontSizeNum + (fontSizeNum * maxTextLength) + fontSizeNum
                else
                    titleSizeNum + (titleSizeNum * titleLength) + titleSizeNum

        -- 文字のmargin-top + 文字列の行数 + 下マージン
        hei =
            (titleSizeNum + fontSizeNum * 2) + (newLineCount * fontSizeNum) + fontSizeNum
    in
        g []
            [ rect
                [ x node.label.x
                , y node.label.y
                , width <| toFloat <| wid
                , height <| toFloat <| hei
                , stroke (Color.black)
                , fill (Fill Color.white)
                , strokeWidth strokeWidthNum
                , onMouseDown node.id
                ]
                [ title [] [ text node.label.value ] ]
            , text_ [ x (node.label.x + fontSizeNum), y (node.label.y + titleSizeNum + fontSizeNum), fill (Fill Color.black) ] [ text titleText ]
            , g []
                (Array.toList
                    (Array.indexedMap (\i dtext -> text_ [ x (node.label.x + fontSizeNum), y (node.label.y + titleSizeNum + fontSizeNum * (3 + (toFloat i))), fontSize fontSizeNum ] [ text dtext ]) texts)
                )

            -- foreignObjectは画像にしたときに表示されないので却下。
            --, foreignObject [ x (node.label.x + fontSizeNum), y (node.label.y + titleSizeNum + fontSizeNum * 2) ] [ div [] [ text dispText ] ]
            , circle
                [ r 10
                , fill (Fill Color.black)
                , stroke (Color.rgba 0 0 0 0)
                , strokeWidth 7
                , onMouseDown node.id
                , cx node.label.x
                , cy node.label.y
                ]
                [ title [] [ text node.label.value ] ]
            ]


forceGraph : Model -> Svg Msg
forceGraph model =
    let
        arrayInformations =
            Array.fromList model.informations
    in
        svg [ viewBox 0 0 w h ]
            [ Graph.edges model.graph
                |> List.map (linkElement model.graph)
                |> g [ class [ "links" ] ]
            , Graph.nodes model.graph
                |> List.map (\node -> nodeElement node arrayInformations)
                |> g [ class [ "nodes" ] ]
            ]



-- let fl = String.toFloat model.value in case fl of Just a -> a _ -> 0
