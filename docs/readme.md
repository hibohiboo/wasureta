## 履歴

### 開発環境作成
[pug, typescript設定時点](https://github.com/hibohiboo/wasureta/tree/c826b63b3a90cfd7c81b3183f94d6ba193185184)  

### デプロイ設定

./bin/firebase-login-token-generate.shを使ってトークンを作成して.envファイルに以下の形式で保存

```
FIREBASE_TOKEN=生成したトークン
```

./bin/firebase-deploy.shでデプロイ

https://wasureta-d6b34.firebaseapp.com/


[デプロイ設定](https://github.com/hibohiboo/wasureta/tree/8df5438e5affb5c3c2339d2b2c81723f81ae22e6)  

### GA導入

[参考][*9]

[GA導入](https://github.com/hibohiboo/wasureta/tree/97c9d30c15815e4389f8a62d7c63cdeac93481ad)  

### elm 導入

[参考][*10]
[参考][*11]
[elm導入](https://github.com/hibohiboo/wasureta/tree/06c13daf973ad13233a1e1132baa789609ca4501)  

### mixin使用

[mixin](https://github.com/hibohiboo/wasureta/tree/77f0e34b1669334e4bd2daad32c60129137f193b)  

### firebaseでの認証
[firebase認証](https://github.com/hibohiboo/wasureta/tree/12ce941e9131378f81151114b10f26b55e9c15ac)  

### elm 0.19
[elm 0.19 試す](https://github.com/hibohiboo/wasureta/tree/9da6239d6721c299cfab336179d88444ba78b72e)  

## jQueryの拡張

* type.d.tsファイルを作って、以下のように記述してやれば、好きな拡張を適用できる。
* もちろん、そのjsライブラリが.d.tsファイルを提供しているならばそちらを使ったほうがよいが、もしない場合のためメモ。

```ts

// JQueryのインタフェースの拡張を行う
interface JQuery {
  sidenav(): JQuery;
}

```

## デプロイ

まずは`./bin/pug.sh`で `dist/html`を作成。その後、`./bin/build.sh`で`dist/app/public`を作成。

## ソース大幅変更

* webpackだとelm-compilerが使えなくなるので、elmでコンパイルした後に、webpackでまとめるだけ。

[変更前](https://github.com/hibohiboo/wasureta/tree/00de494e04baedf6c9f07d7a04348a446705be4f)


## 利用したい技術

[ティラノスクリプト](http://strikeworks.jp/)
[ねこ卓](http://seesaawiki.jp/trpg_tool_guide/d/%A4%CD%A4%B3%C2%EE%B3%B5%CD%D7)
[Udonarium](http://seesaawiki.jp/trpg_tool_guide/d/Udonarium%b3%b5%cd%d7)
[ココフォリア](http://seesaawiki.jp/trpg_tool_guide/d/%a5%b3%a5%b3%a5%d5%a5%a9%a5%ea%a5%a2%b3%b5%cd%d7)
[lotus](http://function.topaz.ne.jp/download/download.html)


## 参考

[SPA ではない Webpack 設定サンプル][*1]  
[Webpackを頑張って設定して、すごい静的サイトジェネレータとして使おう][*2][*][*8]  
[最新版で学ぶwebpack 4入門 – JavaScriptのモジュールバンドラ][*6]  
[Material Design][*3]  
[webpack4の注意点][*4]  
[vue.js webpack4][*5]  
[設定ファイル不要のwebpack 4で、BabelやTypeScriptのゼロコンフィグのビルド環境を作ってみる][*7]  
[FIREBASE AUTHを使ったメール認証・TWITTER認証のサンプル (REACT版)][*12]
[webpackの使い方 chunk][*13]  
[webpackの使い方][*14]  
[chart.js][*15]
[chart.js radar][*16]
[webpack][*17]
[materializeの使いかた][*18]
[TypeScript の型定義ファイルと仲良くなろう][*20]  
[TypeScript で型定義ファイル( d.ts )がないときの対処法][*21]
[Stack Over Flow : typescript document.getElementByIDで HTMLElement | null の型のせいでエラー][*23]
[typescriptでjqueryを拡張][*24]

[*1]:https://syon.github.io/refills/rid/1481295/
[*2]:https://qiita.com/toduq/items/2e0b08bb722736d7968c
[*3]:https://materializecss.com/about.html
[*4]:https://qiita.com/soarflat/items/28bf799f7e0335b68186
[*5]:https://qiita.com/Sapphirus/items/46b3a4c68fefd3ddd658
[*6]:https://ics.media/entry/12140
[*7]:https://qiita.com/clockmaker/items/8620cf6bd99d810dbf2a
[*8]:https://github.com/toduq/webpack-template
[*9]:https://www.leadplus.net/blog/google-tag-manager.html
[*10]:http://pastelinc.hatenablog.com/entry/2018/08/04/114836
[*11]:https://qiita.com/hibohiboo/items/88e0578121079e0671a3
[*12]:https://pigbo.co/posts/363
[*13]:https://qiita.com/soarflat/items/1b5aa7163c087a91877d
[*14]:https://qiita.com/soarflat/items/28bf799f7e0335b68186
[*15]:http://www.chartjs.org/docs/latest/
[*16]:https://misc.0o0o.org/chartjs-doc-ja/axes/radial/linear.html
[*17]:https://github.com/romariolopezc/elm-webpack-4-starter
[*18]:http://masayuki610930.github.io/materialize_sample/
[*19]:https://github.com/webpack-contrib/file-loader
[*20]:http://developer.hatenastaff.com/entry/2016/06/27/140931
[*21]:https://qiita.com/Nossa/items/726cc3e67527e896ed1e
[*22]:https://stackoverflow.com/questions/43218680/document-getelementbyidid-may-be-null
[*23]:https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-0.html#non-null-assertion-operator
[*24]:https://stackoverrun.com/ja/q/11272722
