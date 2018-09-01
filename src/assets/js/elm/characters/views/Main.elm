port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Value, Decoder, decodeString, field, string)
import Json.Decode.Pipeline exposing (decode, required, optional)
-- import Html.Events exposing (..)


port logout : () -> Cmd msg

type alias CharacterParameters = 
  {
      str: Int,
      dex: Int,
      sense: Int,
      mind: Int,
      luck: Int,
      free: Int,
      freeName: String
  }

type alias CharacterImage =
    { src: String,
      filename: String,
      maker: String,
      makerUrl: String
    }

type alias Character =
    { name : String,
      profile: String,
      parameters: CharacterParameters,
      image: Maybe CharacterImage
    }

decoder : Decoder Character
decoder =
    decode Character
        |> Json.Decode.Pipeline.required "name" Decode.string
        |> Json.Decode.Pipeline.required "profile" Decode.string
        |> Json.Decode.Pipeline.required "parameters" parametersDecoder
        |> Json.Decode.Pipeline.optional "image" (Decode.nullable imageDecoder) Nothing

imageDecoder : Decoder CharacterImage
imageDecoder =
    decode CharacterImage
        |> Json.Decode.Pipeline.required "src" Decode.string
        |> Json.Decode.Pipeline.optional "filename" Decode.string ""
        |> Json.Decode.Pipeline.optional "maker" Decode.string ""
        |> Json.Decode.Pipeline.optional "makerUrl" Decode.string ""

parametersDecoder : Decoder CharacterParameters
parametersDecoder =
    decode CharacterParameters
        |> Json.Decode.Pipeline.required "str" Decode.int
        |> Json.Decode.Pipeline.required "dex" Decode.int
        |> Json.Decode.Pipeline.required "sense" Decode.int
        |> Json.Decode.Pipeline.required "mind" Decode.int
        |> Json.Decode.Pipeline.required "luck" Decode.int
        |> Json.Decode.Pipeline.required "free" Decode.int
        |> Json.Decode.Pipeline.required "freeName" Decode.string
        

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
                      ],
                    div[class "row"][text "アクション"],
                    div[class "row"][
                        actionCard "/assets/images/break.png" "殴る" "favorite 【肉体】" "たたく。 壊す。" "http://pictogram2.com/" "ピクトグラム2.0"
                      , actionCard "/assets/images/run.png" "走る" "directions_run 【敏捷】" "逃げる。急ぐ。" "http://pictogram2.com/" "ピクトグラム2.0"
                      , actionCard "/assets/images/search.png" "調べる" "visibility 【知覚】" "見つける。観察。" "http://pictogram2.com/" "ピクトグラム2.0"
                      , actionCard "/assets/images/think.png" "考える" "search 【精神】" "閃く。本を調べる。" "http://pictogram2.com/" "ピクトグラム2.0"
                      , actionCard "/assets/images/animal_ookami_tooboe.png" "野生の勘" "cached 【野生】" "野生の勘で閃きを得る" "https://www.irasutoya.com/" "いらすとや"
                      
                    ]
                  ]
                ]
              ]

charParameter : Character -> Html Msg
charParameter char = 
        div[][
          div[class "row"][
              div[class "col l4"][text "名前"],
              div[class "col l8"][text char.name]
          ],
          charParameters char.parameters,
          div[class "row"][
              div[class "col l4"][text "プロフィール"],
              div[class "col l8"][text char.profile]
          ]
        ]


charImage : Maybe CharacterImage -> Html Msg
charImage image =
      case image of 
          Nothing -> 
            div[][]
          Just image -> 
      let
        fileinfo = (image.maker ++ ":" ++ image.filename)
      in
         div[class "card-image"][
           div[class "pc-image"][
              img[src image.src, alt fileinfo][],
              a[class "card-title black-text", href image.makerUrl][
                text fileinfo
              ] 
           ]
         ]

charParameters : CharacterParameters -> Html Msg
charParameters param = 
          div[class "row"][
                charaParameter "favorite 【肉体】" param.str
              , charaParameter "directions_run 【敏捷】" param.dex
              , charaParameter "visibility 【知覚】" param.sense
              , charaParameter "search 【精神】" param.mind
              , charaParameter "toys 【幸運】" param.luck
              , charaParameter ("cached 【" ++ param.freeName ++ "】") param.free
          ]

charaParameter : String -> Int -> Html Msg
charaParameter param value = 
              div[class "col l6 s12"][
                paramIcon param,
                span[class "pc-param-number"][text (toString value)]
              ]

paramIcon : String -> Html Msg
paramIcon param = i[class "material-icons"][text param]


actionCard : String -> String -> String -> String -> String -> String -> Html Msg
actionCard image name param detail makerUrl   fileInfo = 
    div[class "col s12 m6 l3"][
      div[class "card"][
        div[class "card-image"][
          img[src image, alt name][],
           a[class "card-title black-text", href makerUrl, style [("font-size", "14px")]][text fileInfo] 
        ],
        div[class "card-content"][
          span[class "card-title black-text"][text name],
          ul[class "collection with-header"][
            li[class "collection-header"][paramIcon param],
            li[class "collection-iitem"][text detail]
          ]
        ]
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
