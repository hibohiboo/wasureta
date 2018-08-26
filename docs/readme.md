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



## 参考

[SPA ではない Webpack 設定サンプル][*1]  
[Webpackを頑張って設定して、すごい静的サイトジェネレータとして使おう][*2][*][*8]  
[最新版で学ぶwebpack 4入門 – JavaScriptのモジュールバンドラ][*6]  
[Material Design][*3]  
[webpack4の注意点][*4]  
[vue.js webpack4][*5]  
[設定ファイル不要のwebpack 4で、BabelやTypeScriptのゼロコンフィグのビルド環境を作ってみる][*7]  


[*1]:https://syon.github.io/refills/rid/1481295/
[*2]:https://qiita.com/toduq/items/2e0b08bb722736d7968c
[*3]:https://materializecss.com/about.html
[*4]:https://qiita.com/soarflat/items/28bf799f7e0335b68186
[*5]:https://qiita.com/Sapphirus/items/46b3a4c68fefd3ddd658
[*6]:https://ics.media/entry/12140
[*7]:https://qiita.com/clockmaker/items/8620cf6bd99d810dbf2a
[*8]:https://github.com/toduq/webpack-template
[*9]:https://www.leadplus.net/blog/google-tag-manager.html

