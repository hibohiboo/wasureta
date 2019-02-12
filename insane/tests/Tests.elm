module Tests exposing (..)

import Test exposing (..)
import Expect
import HandoutParser


type alias Handout =
    { x : String

    -- , y : String
    }


testParse : String -> Handout -> (() -> Expect.Expectation)
testParse s ast =
    \_ ->
        Expect.equal ast (HandoutParser.parse s)


all : Test
all =
    describe "HandoutParser"
        [ test "ハンドアウト名" (testParse "ハンドアウト名:てすと" (Handout "てすと"))
        ]
