module Utils.HttpUtil exposing (..)

import Http exposing (..)
import Json.Decode as D


fetchJsonData : (Result Error String -> msg) -> String -> D.Decoder String -> Cmd msg
fetchJsonData toMsg url decoder =
    get
        { url = url
        , expect = expectJson toMsg decoder
        }



-- -- expectJson : (Result Error a -> msg) -> D.Decoder a -> Expect msg
-- -- expectJson toMsg decoder =
-- --     expectStringResponse toMsg <|
-- --         \response ->
-- --             case response of
-- --                 BadUrl_ url ->
-- --                     Err (BadUrl url)
-- --                 Timeout_ ->
-- --                     Err Timeout
-- --                 NetworkError_ ->
-- --                     Err NetworkError
-- --                 BadStatus_ metadata body ->
-- --                     Err (BadStatus metadata.statusCode)
-- --                 GoodStatus_ metadata body ->
-- --                     case D.decodeString decoder body of
-- --                         Ok value ->
-- --                             Ok value
-- --                         Err err ->
--                             Err (BadBody (D.errorToString err))


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



-- fetchStringData : (Result Error String -> msg) -> String -> Cmd msg
-- fetchStringData toMsg url =
--     get
--         { url = url
--         , expect = expectString toMsg
--         }
