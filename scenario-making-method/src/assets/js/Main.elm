port module Main exposing (main)

{-| This demonstrates laying out the characters in Les Miserables
based on their co-occurence in a scene. Try dragging the nodes!
-}

import Browser
import Browser.Events
import ForceDirectedGraph exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ editArea model
        , button [ onClick InformationsUpdate ] [ text "情報項目更新" ]
        , forceGraph model
        ]


editArea : Model -> Html Msg
editArea model =
    div [ class "editor" ]
        [ div []
            [ label [ for "editor" ] [ text "シナリオプロット" ]
            , br [] []
            , textarea
                [ id "editor"
                , onInput Input
                ]
                [ text model.value ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input text ->
            ( ForceDirectedGraph.update msg model, toJs text )

        _ ->
            ( ForceDirectedGraph.update msg model, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



{- {"delay": 5001} -}
