module Utils.HttpUtil exposing (..)

import Http exposing (..)
import Json.Decode as D


fetchJsonData : (Result Error String -> msg) -> String -> D.Decoder String -> Cmd msg
fetchJsonData toMsg url decoder =
    get
        { url = url
        , expect = expectJson toMsg decoder
        }


fetchStringData : (Result Error String -> msg) -> String -> Cmd msg
fetchStringData toMsg url =
    get
        { url = url
        , expect = expectString toMsg
        }


httpErrorToString : Error -> String
httpErrorToString err =
    case err of
        BadUrl _ ->
            "BadUrl"

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus n ->
            "BadStatus" ++ ":" ++ String.fromInt n

        BadBody s ->
            "BadBody: " ++ s
