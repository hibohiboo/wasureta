module Models.ChatEditor exposing (..)

import Json.Decode as D exposing (Decoder, Value)
import Json.Decode.Pipeline exposing (optional, required)
import Models.Chat as Chat exposing (Chat)
import Models.SystemInfo exposing (SystemInfo, SystemNames, initSystemInfo)


type alias ChatEditor =
    { chat : Chat
    , diceFace : Int
    , diceNumber : Int
    , diceCommand : String
    , names : List SystemNames
    , selectedSystemName : String
    , selectedSystemInfo : SystemInfo
    , selectedPrefix : String
    , tableCommand : String
    }


defaultDiceNumber : Int
defaultDiceNumber =
    1


defaultDiceFace : Int
defaultDiceFace =
    10


init =
    ChatEditor Chat.init defaultDiceFace defaultDiceNumber ">5" [] "DiceBot" initSystemInfo "" ""


inputName : String -> ChatEditor -> ChatEditor
inputName val editor =
    { editor | chat = Chat.inputName val editor.chat }


inputText : String -> ChatEditor -> ChatEditor
inputText val editor =
    { editor | chat = Chat.inputText val editor.chat }


inputCreatedAt : Int -> ChatEditor -> ChatEditor
inputCreatedAt val editor =
    { editor | chat = Chat.inputCreatedAt val editor.chat }


inputFace : String -> ChatEditor -> ChatEditor
inputFace val editor =
    { editor | diceFace = Maybe.withDefault 0 (String.toInt val) }


inputDiceNumber : String -> ChatEditor -> ChatEditor
inputDiceNumber val editor =
    { editor | diceNumber = Maybe.withDefault defaultDiceFace (String.toInt val) }


inputNames : List SystemNames -> ChatEditor -> ChatEditor
inputNames val editor =
    { editor | names = val }


inputSystemInfo : SystemInfo -> ChatEditor -> ChatEditor
inputSystemInfo val editor =
    { editor | selectedSystemInfo = val }


inputDiceCommand : String -> ChatEditor -> ChatEditor
inputDiceCommand val editor =
    { editor | diceCommand = val }


inputSelectedSystemName : String -> ChatEditor -> ChatEditor
inputSelectedSystemName val editor =
    { editor | selectedSystemName = val }


inputSelectedPrefix : String -> ChatEditor -> ChatEditor
inputSelectedPrefix val editor =
    { editor | selectedPrefix = val }


inputTableCommand : String -> ChatEditor -> ChatEditor
inputTableCommand val editor =
    { editor | tableCommand = val }


toStringDiceFace : Int -> String
toStringDiceFace face =
    if face == 0 then
        ""

    else
        String.fromInt face
