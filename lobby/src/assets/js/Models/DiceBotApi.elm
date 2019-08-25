module Models.DiceBotApi exposing (..)

import Array exposing (Array)
import Http
import Json.Decode as D exposing (Decoder)
import Models.SystemInfo exposing (SystemInfo, SystemNames)
import Utils.HttpUtil as HttpUtil


apiUrl : String
apiUrl =
    "https://bcdice.herokuapp.com/v1/"


diceRollUrl : String -> String -> String
diceRollUrl system command =
    apiUrl ++ "diceroll?system=" ++ system ++ "&command=" ++ command


diceRollResultDecoder : Decoder String
diceRollResultDecoder =
    D.field "result" D.string


fetchDiceRollResult : (Result Http.Error String -> msg) -> String -> String -> Cmd msg
fetchDiceRollResult toMsg system command =
    HttpUtil.fetchJsonData toMsg (diceRollUrl system command) diceRollResultDecoder


namesUrl : String
namesUrl =
    apiUrl ++ "names"


namesDecoder : Decoder (List SystemNames)
namesDecoder =
    D.field "names" (D.list <| D.map2 SystemNames (D.field "system" D.string) (D.field "name" D.string))


fetchSystemNames : (Result Http.Error String -> msg) -> Cmd msg
fetchSystemNames toMsg =
    HttpUtil.fetchStringData toMsg namesUrl


systemInfoUrl : String -> String
systemInfoUrl system =
    apiUrl ++ "systeminfo?system=" ++ system


fetchSystemInfo : (Result Http.Error String -> msg) -> String -> Cmd msg
fetchSystemInfo toMsg system =
    HttpUtil.fetchStringData toMsg (systemInfoUrl system)


systemInfoDecoder =
    D.field "systeminfo" <|
        D.map4 SystemInfo
            (D.field "name" D.string)
            (D.field "gameType" D.string)
            -- api側がタイポしているので注意 prefixs prefixes
            (D.field "prefixs" (D.list D.string))
            (D.field "info" D.string)



-- versionUrl : String
-- versionUrl =
--     apiUrl ++ "version"
-- type alias ApiVersion =
--     Float
-- type alias BotVersion =
--     Float
-- nameDecoder : Decoder ( ApiVersion, BotVersion )
-- nameDecoder =
--     D.map2 Tuple.pair (D.field "api" D.float) (D.field "bcdice" D.float)
-- systemsDecoder : Decoder (List String)
-- systemsDecoder =
--     D.field "Systems" (D.list D.string)
-- diceRollResultDecoder : Decoder String
-- diceRollResultDecoder =
--     D.field "result" D.string
-- type alias DiceRollResultFull =
--     { ok : Bool
--     , result : String
--     , secret : Bool
--     , dices : List ( DiceRollFaces, DiceRollValue )
--     }
-- diceRollResultFullDecoder : Decoder DiceRollResultFull
-- diceRollResultFullDecoder =
--     D.map4 DiceRollResultFull (D.field "ok" D.bool) (D.field "result" D.string) (D.field "secret" D.bool) (D.field "dices" (D.list dicesDecoder))
-- -- ダイス単位
-- type alias DiceRollFaces =
--     Int
-- type alias DiceRollValue =
--     Int
-- dicesDecoder : Decoder ( DiceRollFaces, DiceRollValue )
-- dicesDecoder =
--     D.map2 Tuple.pair (D.field "faces" D.int) (D.field "value" D.int)
