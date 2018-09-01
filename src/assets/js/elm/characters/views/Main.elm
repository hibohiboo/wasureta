port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Value, Decoder, decodeString, field, string)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Html.Events exposing (..)


port logout : () -> Cmd msg


type alias Character =
    { name : String
    }


decoder : Decoder Character
decoder =
    decode Character
        |> Json.Decode.Pipeline.required "name" Decode.string



decodeCharacterFromJson : Value -> Maybe Character
decodeCharacterFromJson json =
    -- let
    -- _ =
    --     Debug.log "decodeCharacter" json
    -- in
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString decoder >> Result.toMaybe)



-- モデル


type alias Model =
    { char : Maybe Character }


init : Value -> ( Model, Cmd Msg )
init val =
    ( { char = decodeCharacterFromJson val }, Cmd.none )



-- メッセージ


type Msg
    = NoOp
    | Logout



-- ビュー


view : Model -> Html Msg
view model =
    let
        char =
            model.char

        -- _ =
        --     Debug.log "char" model
    in
        case char of
            Nothing ->
                span []
                    [ text "なし"
                    ]

            Just char ->
               div[class "container"][
                div [class "row"][
                  div[class "col l12"][
                    div[class "row"][
                      div[class "col l6"][
                        charaParameter char
                      ],
                                  div[class "col l6"][
                        charImage "/assets/images/gon.jpg"
                                    ]
                      ]
                    ]
                  ]
               ]
charParameter : Character -> Html Msg
charParameter char = 
          div[class "row"][
                       div[class "col l3"][text "名前"],
                        div[class "col l3"][text char.name]
          ]

charImage : String -> Html Msg
charImage url =

              img[src url][]

-- 更新


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Logout ->
            ( { model | char = Nothing }, Cmd.batch [ logout () ] )



-- サブスクリプション(購読)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
