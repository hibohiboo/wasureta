module Models.ChatEditor exposing (..)

import Json.Decode as D exposing (Decoder, Value)
import Json.Decode.Pipeline exposing (optional, required)
import Models.Chat as Chat exposing (Chat)


type alias ChatEditor =
    { chat : Chat
    }


init =
    ChatEditor Chat.init


inputName : String -> ChatEditor -> ChatEditor
inputName val editor =
    { editor | chat = Chat.inputName val editor.chat }


inputText : String -> ChatEditor -> ChatEditor
inputText val editor =
    { editor | chat = Chat.inputText val editor.chat }


inputCreatedAt : Int -> ChatEditor -> ChatEditor
inputCreatedAt val editor =
    { editor | chat = Chat.inputCreatedAt val editor.chat }
