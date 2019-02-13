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
            Handout "e" "e" "e"



-- TODO 実装する


type alias Handout =
    { name : String
    , mission : String
    , shock : String
    }



-- "( 3, 4 )" という文字列を { x = 3, y = 4 } のように解釈するパーサーの定義


point : Parser Handout
point =
    succeed Handout
        |. keyword "[ハンドアウト名]"
        |. spaces
        |. symbol "["
        |= text
        |. symbol "]"
        |. spaces
        |. keyword "[使命]"
        |. spaces
        |. symbol "["
        |= text
        |. symbol "]"
        |. spaces
        |. keyword "[ショック]"
        |. spaces
        |. symbol "["
        |= text
        |. symbol "]"
        |. spaces


text : Parser String
text =
    getChompedString <|
        succeed ()
            |. chompWhile (\c -> c /= ']')



-- )
