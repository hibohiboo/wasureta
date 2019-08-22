module Models.Chat exposing (..)

import Json.Decode as D exposing (Decoder, Value)
import Json.Decode.Pipeline exposing (optional, required)


type alias Chat =
    { name : String
    , text : String
    , createdAt : String
    }


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
        |> required "createdAt" D.string
