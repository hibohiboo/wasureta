module Models.ChatEditor exposing (..)

import Json.Decode as D exposing (Decoder, Value)
import Json.Decode.Pipeline exposing (optional, required)
import Models.Chat as Chat exposing (Chat)


type alias ChatEditor =
    { chat : Chat
    , diceFace : Int
    , diceNumber : Int
    , diceCommand : String
    }


defaultDiceNumber : Int
defaultDiceNumber =
    1


defaultDiceFace : Int
defaultDiceFace =
    10


init =
    ChatEditor Chat.init defaultDiceFace defaultDiceNumber ">5"


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
    { editor | diceFace = Maybe.withDefault defaultDiceNumber (String.toInt val) }


inputDiceNumber : String -> ChatEditor -> ChatEditor
inputDiceNumber val editor =
    { editor | diceNumber = Maybe.withDefault defaultDiceFace (String.toInt val) }


inputDiceCommand : String -> ChatEditor -> ChatEditor
inputDiceCommand val editor =
    { editor | diceCommand = val }
