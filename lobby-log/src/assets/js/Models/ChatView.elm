module Models.ChatView exposing (..)

import Json.Decode as D exposing (Decoder, Value)
import Json.Decode.Pipeline exposing (optional, required)
import Models.Chat exposing (Chat)
import Utils.Time exposing (toDateFromMS)


type alias ChatView =
    { name : String
    , text : String
    , createdAt : String
    }


decodeFromValue : Value -> Maybe ChatView
decodeFromValue val =
    case D.decodeValue decoder val of
        Err a ->
            Nothing

        Ok m ->
            Just m


decoder =
    D.succeed ChatView
        |> required "name" D.string
        |> required "text" D.string
        |> required "createdAt" D.string


fromChat : Chat -> ChatView
fromChat chat =
    ChatView chat.name chat.text (toDateFromMS chat.createdAt)
