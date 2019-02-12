module HtmlParser exposing (..)

import Parser exposing (Parser, (|.), (|=), chompWhile, getChompedString, succeed, symbol, keyword, spaces)


type Node
    = Text String
    | Comment String


parse : String -> Point
parse s =
    case Parser.run point s of
        Ok x ->
            x

        Err _ ->
            Point "error" "error"



-- TODO 実装する


type alias Point =
    { x : String
    , y : String
    }



-- "( 3, 4 )" という文字列を { x = 3, y = 4 } のように解釈するパーサーの定義


point : Parser Point
point =
    succeed Point
        |. symbol "("
        |. spaces
        |= text
        |. spaces
        |. symbol ","
        |. spaces
        |= text
        |. spaces
        |. symbol ")"


text : Parser String
text =
    getChompedString <|
        succeed ()
            |. chompWhile (\c -> Char.isAlphaNum c || c == '_')



-- )
