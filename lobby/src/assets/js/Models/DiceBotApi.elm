module Models.DiceBotApi exposing (..)

import Array exposing (Array)
import Http
import Json.Decode as D exposing (Decoder)
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


fetchDiceRollResultDecoder : (Result Http.Error String -> msg) -> String -> String -> Cmd msg
fetchDiceRollResultDecoder toMsg system command =
    HttpUtil.fetchJsonData toMsg (diceRollUrl system command) diceRollResultDecoder



-- type alias SystemInfoResult =
--     { ok : Bool
--     , systemInfo : SystemInfo
--     }
-- type alias SystemInfo =
--     { name : String
--     , gameType : String
--     , prefixs : List String
--     , info : String
--     }
-- versionUrl : String
-- versionUrl =
--     apiUrl ++ "version"
-- namesUrl : String
-- namesUrl =
--     apiUrl ++ "names"
-- systemsUrl : String
-- systemsUrl =
--     apiUrl ++ "systems"
-- diceRollUrl : String -> String -> String
-- diceRollUrl system command =
--     apiUrl ++ "diceroll?" ++ system ++ "&command=" ++ command
-- systemInfoUrl : String -> String
-- systemInfoUrl system =
--     apiUrl ++ "systeminfo?system=" ++ system
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
