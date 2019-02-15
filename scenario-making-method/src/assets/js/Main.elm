module Main exposing (main)

{-| This demonstrates laying out the characters in Les Miserables
based on their co-occurence in a scene. Try dragging the nodes!
-}

import Browser
import Browser.Events
import ForceDirectedGraph exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html.Html Msg
view model =
    div []
        [ forceGraph model
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = \msg model -> ( update msg model, Cmd.none )
        , subscriptions = subscriptions
        }



-- view : Model -> Html.Html Msg
-- view model =
--     div []
--         [ editArea model
--         , forceGraph model
--         ]
-- editArea : Model -> Html Msg
-- editArea model =
--     div [ class "editor" ]
--         [ div []
--             [ label [ for "editor" ] [ text "シナリオプロット" ]
--             , textarea
--                 [ id "editor"
--                 , onInput Input
--                 ]
--                 [ text model.value ]
--             ]
--         ]
{- {"delay": 5001} -}
