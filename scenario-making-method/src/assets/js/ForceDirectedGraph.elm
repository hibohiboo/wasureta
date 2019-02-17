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


w : Float
w =
    990


h : Float
h =
    504


type Msg
    = DragStart NodeId ( Float, Float )
    | DragAt ( Float, Float )
    | DragEnd ( Float, Float )
    | Tick Time.Posix
    | Input String


type alias Model =
    { drag : Maybe Drag
    , graph : Graph Entity ()
    , simulation : Force.State NodeId
    , value : String
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
        graph =
            Graph.mapContexts initializeNode miserablesGraph

        link { from, to } =
            { source = from
            , target = to
            , distance = 300
            , strength = Just 1.001
            }

        forces =
            [ Force.customLinks 0 <| List.map link <| Graph.edges graph
            , Force.manyBody <| List.map .id <| Graph.nodes graph
            , Force.center (w / 2) (h / 2)
            ]
    in
        ( Model Nothing graph (Force.simulation forces) "10", Cmd.none )


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
update msg ({ drag, graph, simulation, value } as model) =
    case msg of
        Tick t ->
            let
                ( newState, list ) =
                    Force.tick simulation <| List.map .label <| Graph.nodes graph
            in
                case drag of
                    Nothing ->
                        Model drag (updateGraphWithList graph list) newState value

                    Just { current, index } ->
                        Model drag
                            (Graph.update index
                                (Maybe.map (updateNode current))
                                (updateGraphWithList graph list)
                            )
                            newState
                            value

        DragStart index xy ->
            Model (Just (Drag xy xy index)) graph simulation value

        DragAt xy ->
            case drag of
                Just { start, index } ->
                    Model (Just (Drag start xy index))
                        (Graph.update index (Maybe.map (updateNode xy)) graph)
                        (Force.reheat simulation)
                        value

                Nothing ->
                    Model Nothing graph simulation value

        DragEnd xy ->
            case drag of
                Just { start, index } ->
                    Model Nothing
                        (Graph.update index (Maybe.map (updateNode xy)) graph)
                        simulation
                        value

                Nothing ->
                    Model Nothing graph simulation value

        Input val ->
            Model Nothing graph (Force.reheat simulation) val


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


titleSize =
    14



-- フォントサイズ (px) css参照


fontSizeNum =
    12



-- 1行の文字数


maxTextLength =
    14



-- 線の太さ


strokeWidthNum =
    3


nodeElement node rl =
    let
        dispText =
            "10:姿を消すとき、ヘイロ\nン絡みのトラブルに巻き\n込まれていたようだ。\n11:その他のテストを行うこと。成功すればその他なんか適用にうまくできるような気がする。"

        --1行ずつ分割する
        texts =
            Array.fromList (String.lines dispText)

        -- 左パディング＋文字の大きさ*文字の長さ＋右パディング
        wid =
            fontSizeNum + (fontSizeNum * maxTextLength) + fontSizeNum

        -- 改行の数
        newLineCount =
            List.length (String.split "\n" dispText)

        -- 文字のmargin-top + 文字列の行数 + 下マージン
        hei =
            (titleSize + fontSizeNum * 2) + (((String.length dispText) // maxTextLength + newLineCount) * fontSizeNum) + fontSizeNum
    in
        g []
            [ rect
                [ x node.label.x
                , y node.label.y
                , width wid
                , height <| toFloat <| hei
                , stroke (Color.black)
                , fill (Fill Color.white)
                , strokeWidth strokeWidthNum
                , onMouseDown node.id
                ]
                [ title [] [ text node.label.value ] ]
            , text_ [ x (node.label.x + fontSizeNum), y (node.label.y + titleSize + fontSizeNum), fill (Fill Color.black) ] [ text "タイトル" ]
            , g []
                (Array.toList
                    (Array.indexedMap (\i dtext -> text_ [ x (node.label.x + fontSizeNum), y (node.label.y + titleSize + fontSizeNum * (3 + (toFloat i))), fontSize fontSizeNum ] [ text dtext ]) texts)
                )

            --, foreignObject [ x (node.label.x + fontSizeNum), y (node.label.y + titleSize + fontSizeNum * 2) ] [ div [] [ text dispText ] ]
            -- circle
            --     [ r 30
            --     , fill (Fill Color.black)
            --     , stroke (Color.rgba 0 0 0 0)
            --     , strokeWidth 7
            --     , onMouseDown node.id
            --     , cx node.label.x
            --     , cy node.label.y
            --     ]
            --     [ title [] [ text node.label.value ] ]
            -- , text_ [ x node.label.x, y node.label.y, fill (Fill Color.white) ] [ text "test" ]
            ]


forceGraph : Model -> Svg Msg
forceGraph model =
    svg [ viewBox 0 0 w h ]
        [ Graph.edges model.graph
            |> List.map (linkElement model.graph)
            |> g [ class [ "links" ] ]
        , Graph.nodes model.graph
            |> List.map (\node -> nodeElement node (valueToFloat model))
            |> g [ class [ "nodes" ] ]
        ]


valueToFloat : Model -> Float
valueToFloat model =
    let
        fl =
            String.toFloat model.value
    in
        case fl of
            Just a ->
                a

            Nothing ->
                1.0



-- let fl = String.toFloat model.value in case fl of Just a -> a _ -> 0
