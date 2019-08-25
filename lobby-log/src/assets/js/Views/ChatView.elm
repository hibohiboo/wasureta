module Views.ChatView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


chatMessage : String -> String -> String -> Html msg
chatMessage name textMessage createdAt =
    li [ class "collection-item grey darken-4" ]
        [ span [ class "chatlog--title" ] [ text name ]
        , span [] [ text textMessage ]
        , span [ class "chatlog--time" ] [ text createdAt ]
        ]
