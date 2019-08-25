module Models.Chat exposing (..)

import Http
import Json.Decode as D exposing (Decoder, Value)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as E
import Utils.FirestoreApi as FS
import Utils.HttpUtil as HttpUtil


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


fetchMessages : (Result Http.Error String -> msg) -> String -> Cmd msg
fetchMessages toMsg token =
    HttpUtil.fetchStringData toMsg (FS.chatsUrlWithPageToken token)


decoderFromFS : Decoder Chat
decoderFromFS =
    D.succeed Chat
        |> required "name" FS.string
        |> required "text" FS.string
        |> required "createdAt" FS.int


chatsDecoderFromFS : Decoder (List Chat)
chatsDecoderFromFS =
    D.at [ "documents" ] <| (D.list <| FS.fields <| D.at [ "common", "mapValue", "fields" ] <| decoderFromFS)
