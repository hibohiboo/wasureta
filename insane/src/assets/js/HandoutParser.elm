module HandoutParser exposing (..)

import Parser exposing (Parser, (|.), (|=), chompWhile, getChompedString, succeed, symbol, keyword, spaces)


type Node
    = Text String
    | Comment String


parse : String -> Handout
parse s =
    case Parser.run point s of
        Ok x ->
            x

        Err _ ->
            Handout "error"



-- TODO 実装する


type alias Handout =
    { x : String
    }



-- "( 3, 4 )" という文字列を { x = 3, y = 4 } のように解釈するパーサーの定義


point : Parser Handout
point =
    succeed Handout
        |. keyword "ハンドアウト名:"
        |. spaces
        |= text


text : Parser String
text =
    getChompedString <|
        succeed ()
            |. chompWhile (\c -> c /= '(' && c /= ')' && c /= ',' && c /= ' ')



-- )
