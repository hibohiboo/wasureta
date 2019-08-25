module Utils.FirestoreApi exposing (..)

import Array exposing (Array)
import Json.Decode as D exposing (Decoder)



-- functionsを使った取得URL


databaseUrl =
    "https://firestore.googleapis.com/v1/projects/wasureta-d6b34/databases"


chatsUrl : String
chatsUrl =
    databaseUrl ++ "/(default)/documents/chattools/lobby/rooms/Lobby/messages/"


pageLimit : Int
pageLimit =
    1000


chatsUrlWithLimit : String
chatsUrlWithLimit =
    chatsUrl ++ "?pageSize=" ++ String.fromInt pageLimit


chatsUrlWithPageToken : String -> String
chatsUrlWithPageToken token =
    chatsUrl ++ "?pageSize=" ++ String.fromInt pageLimit ++ "&pageToken=" ++ token



-- デコーダ


fields : Decoder a -> Decoder a
fields decoder =
    D.at [ "fields" ] decoder


list : Decoder a -> Decoder (List a)
list decoder =
    D.oneOf
        [ D.at [ "arrayValue", "values" ] <| D.list (D.at [ "mapValue", "fields" ] decoder)
        , D.at [ "arrayValue" ] <| D.succeed []
        ]


array : Decoder a -> Decoder (Array a)
array decoder =
    D.oneOf
        [ D.at [ "arrayValue", "values" ] <| D.array (D.at [ "mapValue", "fields" ] decoder)
        , D.at [ "arrayValue" ] <| D.succeed Array.empty
        ]


string : Decoder String
string =
    D.at [ "stringValue" ] D.string


int : Decoder Int
int =
    D.map (\x -> Maybe.withDefault 0 (String.toInt x)) <| D.at [ "integerValue" ] D.string


timestamp : Decoder String
timestamp =
    D.at [ "timestampValue" ] D.string


bool : Decoder Bool
bool =
    D.at [ "booleanValue" ] D.bool


decodeFromJsonHelper : Decoder a -> a -> String -> a
decodeFromJsonHelper decoder defaultValue s =
    case D.decodeString decoder s of
        Ok val ->
            val

        Err _ ->
            defaultValue


nextTokenDecoder : Decoder String
nextTokenDecoder =
    D.at [ "nextPageToken" ] D.string


nextTokenFromJson : String -> String
nextTokenFromJson json =
    case D.decodeString nextTokenDecoder json of
        Ok token ->
            token

        Err _ ->
            "last"
