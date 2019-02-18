module Tests exposing (..)

import Test exposing (..)
import Expect
import InfoParser
import InfoToData
import Graph


testParse : String -> Maybe (List InfoParser.Info) -> (() -> Expect.Expectation)
testParse s ast =
    \_ ->
        Expect.equal ast (InfoParser.parse s)


all : Test
all =
    describe "UnitTests"
        [ describe "InfoParser"
            [ test "情報" (testParse testText (Just [ expectInfo ]))
            , test "複数の情報" (testParse (testText ++ testText) (Just [ expectInfo, expectInfo ]))
            , test "リストがない場合" (testParse emptyListText (Just [ expectEnptyListInfo ]))
            ]
        , describe "InfoData"
            [ test "情報->グラフ用データ" (testData [ sourceInfo ] expectData)
            , test "情報->グラフ用データ2" (testData [ sourceInfo, sourceInfo ] expectData2)
            , test "リストがない場合" (testData [ sourceInfoEmptyLink ] expectData3)
            ]
        ]


expectInfo : InfoParser.Info
expectInfo =
    InfoParser.Info "てすと" "しめ\nい" [ 1, 2 ] "red"


testText : String
testText =
    "//コメント"
        ++ "\n[タイトル][てすと]"
        ++ "\n[情報][しめ\nい]"
        ++ "\n[リンク先][1,2]"
        ++ "\n[色][red]"
        ++ "\n----\n"


expectEnptyListInfo : InfoParser.Info
expectEnptyListInfo =
    InfoParser.Info "てすと" "しめ\nい" [] "red"


emptyListText : String
emptyListText =
    "//コメント"
        ++ "\n[タイトル][てすと]"
        ++ "\n[情報][しめ\nい]"
        ++ "\n[リンク先][]"
        ++ "\n[色][red]"
        ++ "\n----\n"



-- データのテスト


testData : List InfoParser.Info -> Graph.Graph String () -> (() -> Expect.Expectation)
testData informations ast =
    \_ ->
        Expect.equal ast (InfoToData.toData informations)


sourceInfo : InfoParser.Info
sourceInfo =
    InfoParser.Info "Myriel" "title" [ 1, 2 ] "red"


expectData =
    Graph.fromNodeLabelsAndEdgePairs
        [ "Myriel"
        ]
        [ ( 0, 1 )
        , ( 0, 2 )
        ]


expectData2 =
    Graph.fromNodeLabelsAndEdgePairs
        [ "Myriel"
        , "Myriel"
        ]
        [ ( 0, 1 )
        , ( 0, 2 )
        , ( 1, 1 )
        , ( 1, 2 )
        ]


sourceInfoEmptyLink =
    InfoParser.Info "Myriel" "title" [] "red"


expectData3 =
    Graph.fromNodeLabelsAndEdgePairs
        [ "Myriel"
        ]
        []
