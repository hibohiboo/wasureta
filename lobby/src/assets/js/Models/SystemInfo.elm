module Models.SystemInfo exposing (..)


type alias SystemNames =
    { system : String
    , name : String
    }


type alias SystemInfoResult =
    { ok : Bool
    , systemInfo : SystemInfo
    }


type alias SystemInfo =
    { name : String
    , gameType : String
    , prefixes : List String
    , info : String
    }


initSystemInfo =
    SystemInfo "DiceBot" "DiceBot" [] "【ダイスボット】チャットにダイス用の文字を入力するとダイスロールが可能\n入力例）２ｄ６＋１\u{3000}攻撃！\n出力例）2d6+1\u{3000}攻撃！\n\u{3000}\u{3000}\u{3000}\u{3000}  diceBot: (2d6) → 7\n上記のようにダイス文字の後ろに空白を入れて発言する事も可能。\n以下、使用例\n\u{3000}3D6+1>=9 ：3d6+1で目標値9以上かの判定\n\u{3000}1D100<=50 ：D100で50％目標の下方ロールの例\n\u{3000}3U6[5] ：3d6のダイス目が5以上の場合に振り足しして合計する(上方無限)\n\u{3000}3B6 ：3d6のダイス目をバラバラのまま出力する（合計しない）\n\u{3000}10B6>=4 ：10d6を振り4以上のダイス目の個数を数える\n\u{3000}(8/2)D(4+6)<=(5*3)：個数・ダイス・達成値には四則演算も使用可能\n\u{3000}C(10-4*3/2+2)：C(計算式）で計算だけの実行も可能\n\u{3000}choice[a,b,c]：列挙した要素から一つを選択表示。ランダム攻撃対象決定などに\n\u{3000}S3d6 ： 各コマンドの先頭に「S」を付けると他人結果の見えないシークレットロール\n\u{3000}3d6/2 ： ダイス出目を割り算（切り捨て）。切り上げは /2U、四捨五入は /2R。\n\u{3000}D66 ： D66ダイス。順序はゲームに依存。D66N：そのまま、D66S：昇順。\n"
