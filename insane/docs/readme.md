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

[elm webpack starter][*1]  
[elm で HTML パーサを作った][*2]  
[elm で markdown パーサを作った][*3]  
[elm parser][*4]  
[backtracable を理解][*5]  
[parser公式docs][*6]  
[text area sample][*7]  
[insane同人誌の作り方][*8]  
[goole font 候補1][*9][候補2][*10][候補3][*11]
[force example][*12]

[*1]:https://github.com/simonh1000/elm-webpack-starter/blob/master/package.json
[*2]:http://jinjor-labo.hatenablog.com/entry/2016/09/11/222251
[*3]:https://scrapbox.io/gaaamii/Elm%E3%81%A7Markdown%E3%82%A8%E3%83%87%E3%82%A3%E3%82%BF%E3%82%92%E4%BD%9C%E3%82%8B%E3%81%BE%E3%81%A7%E3%81%AE%E9%81%93%E3%81%AE%E3%82%8A
[*4]:https://qiita.com/jinjor/items/d0d4b83b530251df913e
[*5]:https://qiita.com/arowM/items/19f2dbc6d04dcddb6000
[*6]:https://package.elm-lang.org/packages/elm/parser/latest/Parser
[*7]:https://qiita.com/jinjor/items/3ebeb56702b11685b0df
[*8]:https://twitter.com/i/moments/1029048187733008384
[*9]:https://fonts.google.com/specimen/Nanum+Brush+Script
[*10]:https://fonts.google.com/specimen/IM+Fell+DW+Pica+SC
[*11]:https://fonts.google.com/specimen/East+Sea+Dokdo
[*12]:https://code.gampleman.eu/elm-visualization/ForceDirectedGraph/