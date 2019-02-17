module InfoParser exposing (parse, Handout)

import Parser exposing (Parser, (|.), (|=), chompWhile, getChompedString, succeed, symbol, keyword, spaces, loop, Step(..), map, oneOf)


parse : String -> Maybe (List String)
parse s =
    case Parser.run handouts s of
        Ok x ->
            Just x

        Err _ ->
            Nothing


handouts : Parser (List Handout)
handouts =
    loop [] handoutsHelp


handoutsHelp : List Handout -> Parser (Step (List Handout) (List Handout))
handoutsHelp revHandouts =
    oneOf
        [ succeed (\stmt -> Loop (stmt :: revHandouts))
            |= handout
            |. symbol "\n"
        , succeed ()
            |> map (\_ -> Done (List.reverse revHandouts))
        ]


{-| Parse Handout.

以下のフォーマットのテキストをパースする

[ハンドアウト名][てすと]
[使命][しめい]
[ショック][PC1]
[秘密][秘密あのねのね]

-}
handout : Parser String
handout =
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
