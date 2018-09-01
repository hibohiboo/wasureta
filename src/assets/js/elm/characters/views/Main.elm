port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Value, Decoder, decodeString, field, string)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Html.Events exposing (..)


port logout : () -> Cmd msg

type alias CharacterImage =
    { src: String,
      filename: String,
      maker: String,
      makerUrl: String
    }
type alias Character =
    { name : String,
      image: Maybe CharacterImage
    }

imageDecoder : Decoder CharacterImage
imageDecoder =
    decode CharacterImage
        |> Json.Decode.Pipeline.required "src" Decode.string
        |> Json.Decode.Pipeline.optional "filename" Decode.string ""
        |> Json.Decode.Pipeline.optional "maker" Decode.string ""
        |> Json.Decode.Pipeline.optional "makerUrl" Decode.string ""

decoder : Decoder Character
decoder =
    decode Character
        |> Json.Decode.Pipeline.required "name" Decode.string
        |> Json.Decode.Pipeline.optional "image" (Decode.nullable imageDecoder) Nothing


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
                div [class "card"][
                  div[class "card-content"][
                    span[class "card-title"][
                      text char.name
                    ],
                    div[class "row"][
                      div[class "col m7 push-m5 s12"][
                        charImage char.image
                      ],
                      div[class "col m5 pull-m7 s12"][
                        charParameter char
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

charImage : Maybe CharacterImage -> Html Msg
charImage image =
      case image of 
          Nothing -> 
            div[][]
          Just image -> 
         div[class "card-image"][
           div[class "pc-image"][
              img[src image.src][]
           ]
         ]


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
