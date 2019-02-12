module Tests exposing (..)

import Test exposing (..)
import Expect
import HtmlParser


type alias Point =
    { x : String
    , y : String
    }


testParse : String -> Point -> (() -> Expect.Expectation)
testParse s ast =
    \_ ->
        Expect.equal ast (HtmlParser.parse s)


all : Test
all =
    describe "HtmlParser"
        [ test "(1,2)" (testParse "(1,2)" (Point "1" "2"))
        ]
