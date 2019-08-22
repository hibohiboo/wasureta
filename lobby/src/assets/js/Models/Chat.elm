module Models.Chat exposing (..)

import Json.Decode as D exposing (Decoder, Value)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as E


type alias Chat =
    { name : String
    , text : String
    , createdAt : Int
    }


init =
    Chat "" "" 0


inputName : String -> Chat -> Chat
inputName val chat =
    { chat | name = val }


inputText : String -> Chat -> Chat
inputText val chat =
    { chat | text = val }


inputCreatedAt : Int -> Chat -> Chat
inputCreatedAt val chat =
    { chat | createdAt = val }


decodeFromValue : Value -> Maybe Chat
decodeFromValue val =
    case D.decodeValue decoder val of
        Err a ->
            Nothing

        Ok m ->
            Just m


decoder =
    D.succeed Chat
        |> required "name" D.string
        |> required "text" D.string
        |> required "createdAt" D.int


encodeToValue : Chat -> Value
encodeToValue chat =
    E.object
        [ ( "name", E.string chat.name )
        , ( "text", E.string chat.text )
        , ( "createdAt", E.int chat.createdAt )
        ]
