module HandoutParser exposing (..)

import Parser exposing (Parser, (|.), (|=), chompWhile, getChompedString, succeed, symbol, keyword, spaces)


type Node
    = Text String
    | Comment String


parse : String -> Maybe Handout
parse s =
    case Parser.run point s of
        Ok x ->
            Just x

        Err _ ->
            Nothing


type alias Handout =
    { name : String
    , mission : String
    , shock : String
    , secret : String
    }


{-| Parse Handout.

以下のフォーマットのテキストをパースする

[ハンドアウト名][てすと]
[使命][しめい]
[ショック][PC1]
[秘密][秘密あのねのね]

-}
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
        |. keyword "[秘密]"
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
