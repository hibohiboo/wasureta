module InfoParser exposing (parse, Info)

import Parser exposing (Parser, (|.), (|=), chompWhile, getChompedString, succeed, symbol, keyword, spaces, loop, Step(..), map, oneOf, int, lazy)


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
    , list : List Int
    }


infomations : Parser (List Info)
infomations =
    loop [] infomationsHelp


infomationsHelp : List Info -> Parser (Step (List Info) (List Info))
infomationsHelp revInfomations =
    oneOf
        [ succeed (\stmt -> Loop (stmt :: revInfomations))
            |= info
            |. spaces
            |. symbol "----"
            |. spaces
        , succeed ()
            |> map (\_ -> Done (List.reverse revInfomations))
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
        |. keyword "[リンク先]"
        |. spaces
        |. symbol "["
        |= intValues
        |. symbol "]"
        |. spaces


text : Parser String
text =
    getChompedString <|
        succeed ()
            |. chompWhile (\c -> c /= ']')


intValues : Parser (List Int)
intValues =
    oneOf
        [ succeed (::)
            |= int
            |= intValuesTail
        , succeed []
        ]


intValuesTail : Parser (List Int)
intValuesTail =
    oneOf
        [ succeed (::)
            |. symbol ","
            |= int
            |= lazy (\_ -> intValuesTail)
        , succeed []
        ]



-- )
