module InfoParser exposing (parse, Info)

import Parser exposing (Parser, (|.), (|=), chompWhile, getChompedString, succeed, symbol, keyword, spaces, loop, Step(..), map, oneOf)


{-| Parse Info.

以下のフォーマットのテキストをパースする

[タイトル][てすと]
[情報][しめい]

-}
parse : String -> Maybe (List Info)
parse s =
    case Parser.run infomations s of
        Ok x ->
            Just x

        Err _ ->
            Nothing


type alias Info =
    { title : String
    , info : String
    }


infomations : Parser (List Info)
infomations =
    loop [] infomationsHelp


infomationsHelp : List Info -> Parser (Step (List Info) (List Info))
infomationsHelp revinfomations =
    oneOf
        [ succeed (\stmt -> Loop (stmt :: revinfomations))
            |= info
            |. spaces
            |. symbol "----"
            |. spaces
        , succeed ()
            |> map (\_ -> Done (List.reverse revinfomations))
        ]


info : Parser Info
info =
    succeed Info
        |. spaces
        |. (Parser.lineComment "//")
        |. spaces
        |. keyword "[タイトル]"
        |. spaces
        |. symbol "["
        |= text
        |. symbol "]"
        |. spaces
        |. keyword "[情報]"
        |. spaces
        |. symbol "["
        |= text
        |. symbol "]"
        |. spaces
        |. (Parser.lineComment "//")
        |. spaces


text : Parser String
text =
    getChompedString <|
        succeed ()
            |. chompWhile (\c -> c /= ']')



-- )
