module Tests exposing (..)

import Test exposing (..)
import Expect
import HandoutParser


testParse : String -> Maybe HandoutParser.Handout -> (() -> Expect.Expectation)
testParse s ast =
    \_ ->
        Expect.equal ast (HandoutParser.parse s)


all : Test
all =
    describe "HandoutParser"
        [ test "ハンドアウト" (testParse testText (Just expectHandout))
        ]


expectHandout : HandoutParser.Handout
expectHandout =
    HandoutParser.Handout "てすと" "しめ\nい" "PC1"


testText : String
testText =
    "[ハンドアウト名][てすと]"
        ++ "\n[使命][しめ\nい]"
        ++ "\n[ショック][PC1]"
