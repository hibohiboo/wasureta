module BackCanvas exposing (backCanvas, getPointCircleLine)

import Canvas exposing (..)
import Color
import Html exposing (Html)
import Html.Attributes exposing (style, class)
import Array
import InfoParser exposing (Info)


{-|

    リンク設定画面の背景に、リンクをつないだノード同士のリンクを描画する
-}
backCanvas : Int -> Int -> Float -> Float -> List Info -> List Renderable
backCanvas width height rad r informations =
    [ shapes [ fill Color.white ] [ rect ( 0, 0 ) (toFloat width) (toFloat height) ]
    , shapes
        [ stroke Color.black
        , lineWidth 2
        ]
        (Array.fromList informations
            |> Array.indexedMap
                (\i info ->
                    info.list
                        -- リンク先のリストごとに線を引く
                        |> List.map
                            -- 座標(リンク先, 自身）
                            (\n -> drawLine ( biasPoint (getPointCircleLine n rad r), biasPoint (getPointCircleLine i rad r) ))
                )
            |> Array.toList
            |> List.concat
         -- 二重のListになっているものを一つのリストに展開する
        )
    ]


{-|

    getPointCircleLineで取得できるのは、div要素の左上の座標。
    描画されている円の中心に合わせるためにバイアスをかけて調整。
-}
biasPoint ( x, y ) =
    ( x + 15, y + 30 )


drawLine ( start, end ) =
    path start [ lineTo end ]


{-| i番目の円周上の座標を取得する。

i i番目
rad １つあたりの角度（ラジアン）
r 円の半径

-}
getPointCircleLine : Int -> Float -> Float -> ( Float, Float )
getPointCircleLine i rad r =
    let
        fi =
            toFloat i

        x =
            cos (rad * fi) * r + r

        y =
            sin (rad * fi) * r + r
    in
        ( x, y )
