module Tests exposing (..)

import Test exposing (..)
import Expect
import InfoParser


testParse : String -> Maybe (List InfoParser.Info) -> (() -> Expect.Expectation)
testParse s ast =
    \_ ->
        Expect.equal ast (InfoParser.parse s)


all : Test
all =
    describe "InfoParser"
        [ test "情報" (testParse testText (Just [ expectInfo ]))
        , test "複数の情報" (testParse (testText ++ testText) (Just [ expectInfo, expectInfo ]))
        ]


expectInfo : InfoParser.Info
expectInfo =
    InfoParser.Info "てすと" "しめ\nい"


testText : String
testText =
    "\n//コメント"
        ++ "\n[タイトル][てすと]"
        ++ "\n[情報][しめ\nい]"
        ++ "\n//コメント"
        ++ "\n----"
