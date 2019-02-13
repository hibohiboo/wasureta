module Tests exposing (..)

import Test exposing (..)
import Expect
import HandoutParser


type alias Handout =
    { name : String
    , mission : String
    }


testParse : String -> Handout -> (() -> Expect.Expectation)
testParse s ast =
    \_ ->
        Expect.equal ast (HandoutParser.parse s)


all : Test
all =
    describe "HandoutParser"
        [ test "ハンドアウト" (testParse testText expectHandout)
        ]


expectHandout : Handout
expectHandout =
    Handout "てすと" "しめい"


testText : String
testText =
    "ハンドアウト名:てすと"
        ++ "\n使命:しめい"
