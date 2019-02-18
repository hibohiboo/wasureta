## starterを素直に動かす。

[初期設定時点](https://github.com/hibohiboo/wasureta/tree/167566e4820be1ec3a04eae4de282842d9b07e89)  

## アジャイル

### インセプションデッキ

##  我われはなぜここにいるのか？

* インセインのカードを簡単に印刷したい
* 同様のサイトがない
* カード番号をつけたい


### プロジェクトの根幹に関わる理由

インセインという好きなシステムを遊びやすくしたい。

## パッケージデザイン

* インセインの秘密置き場
* 素敵な写真

### 最高のキャッチコピー

秘密を簡単印刷

### ユーザーへのアピール

* インストール不要。ブラウザで使用可能。
* PDF印刷でA4の紙に印刷可能
* お手軽

## エレベータピッチ

* 秘密のカードを作るのが面倒なので楽したい
* インセインのゲームマスター向けの「インセインの秘密置き場」は、「TRPG便利ツール」です。
* これは、「最新の技術」があり、「PDF配布」と違って、「簡単入力」が備わっています。

## やらないことリスト

* やる
  * やると決めた理由
* やらない
  * やらないと決めた理由
* 後で決める
  * 後で決めるとした理由

### やる
* A4の印刷デザイン
* ブラウザに保存

### やらない

* div要素での入力
  * 一般的なインタフェースではない
  * シンプルさにかける
  * テキストファイルでの読み込みも考えたい

### 後で決める
* 共有
  * ログイン機能などが少し面倒



## 解決案を描く

* 概要レベルのアーキテクチャ設計図の画像

### 採用する技術

* Typescript, elm
* vscode

##  夜も眠れなくなるような問題は何だろう？

* デザイン崩れ

##  期間を見極める

[ざっくりしたタイムラインの画像]

* あくまで推測であって、確約するものではありません。

## 何をあきらめるのか

|max|>>>|>>>|>>>|min|項目|
|:--|:--|:--|:--|:--|:--|
|o|||||使い勝手|
||o||||とにかくシンプルに！|

## パーサ

[*3][*3]を参考に作成。

[Circle CI動作確認時点](https://github.com/hibohiboo/wasureta/tree/fa91ef899596a921f00d2f256641fda99f4a1751)  

### ハンドアウト１つのパース

[Circle ハンドアウト１つのパース](https://github.com/hibohiboo/wasureta/tree/939befe0ebdc4a0bd2b3c2f609972695e82b580c)  

### ハンドアウト複数パース

[Circle ハンドアウト複数のパース](https://github.com/hibohiboo/wasureta/tree/3bc393dcc750e782ab1a8c6785e694b27d0d983e)  


## 参考

[svgを画像として保存][*1]  
[関数型よく知らない人のelm入門 番外編 - 失敗した設計たち][*2]  
[decoder a ][*3]  
[解析][*4]
[font-awe-some][*5]  
[start font awe some][*6]
[シナリオの作り方][*7]  
[elm graph][*8]  
[spa][*9]  
[visual][*10]  
[svg d3][*11]   
[svg elm][*12]  
[svg で改行][*13]  
[svg text][*14]  
[font][*16]  
[text][*17]  
[svg to png][*18]
[css secret ][*19]
[css animation][*20]

[*1]:https://qiita.com/norami_dream/items/8751708e49a66f6352b8
[*2]:http://nexus1.hatenablog.com/entry/2017/06/21/231548
[*3]:https://qiita.com/ymtszw/items/1cabbdbda4273b4c1978
[*4]:https://qiita.com/jinjor/items/d0d4b83b530251df913e
[*5]:https://niwaka-web.com/fontawsome5_css/
[*6]:https://fontawesome.com/start
[*7]:http://transmitter.seesaa.net/article/437904513.html  
[*8]:https://package.elm-lang.org/packages/elm-community/graph/latest/Graph
[*9]:https://qiita.com/shuhei/items/53adf6a09cd5ceae62a9
[*10]:https://package.elm-lang.org/packages/gampleman/elm-visualization/latest/
[*11]:https://qiita.com/daxanya1/items/734e65a7ca58bbe2a98c
[*12]:https://package.elm-lang.org/packages/elm-community/typed-svg/latest/TypedSvg#text_
[*13]:https://bl.ocks.org/shimizu/44ac0be6f0ce6e75bd62
[*14]:https://developer.mozilla.org/ja/docs/Web/SVG/Element/text
[*15]:https://gist.github.com/h3h/ce339825f2ba8fe1e4d3bf2d1a3e60da
[*16]:http://useyan.x0.com/s/html/mono-font.htm
[*17]:http://defghi1977.html.xdomain.jp/tech/svgMemo/svgMemo_08.htm
[*18]:https://qiita.com/skryoooo/items/a37455bef54321a6195a
[*19]:http://play.csssecrets.io/
[*20]:https://commte.net/5082
