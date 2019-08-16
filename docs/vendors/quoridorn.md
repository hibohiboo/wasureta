## 環境変数の設定

VUE_APP_BASE_URL="quoridorn"
QUORIDORN_SKYWAY_KEY=Skywayのキー

## skywayのキーの設定スクリプトの修正
動作しなかったので、絶対パスに修正

CONNECT_YAML="/app/dist/static/conf/connect.yaml"

## public/static/conf/bgm.ymlの設定

入室するとアルセットのyoutubeが流れる設定だったので消去

## public/index.htmlに含まれていない画像があったので削除
プレロードでyukari.pngというファイルが読み込まれていたが、
そのファイルは入っていなかったため削除

## src/component/Character.vueとStandImageComponent.vueの修正
this.timer:numberが指定されていたが、setTimeoutの戻り値が、
nodeとbrowserで異なるので、windows.setTimeoutと明示。

```
this.timer = window.setTimeout(() => {
```

なお、node.jsだとnumberではなくTimerが戻り値となる。

## 開発環境を動かす。


public/static/conf/connect.yamlにSkyWayのカギを指定する必要あり。

変更はgitにあげる意味がないので、
git update-index --skip-worktree ./public/static/conf/connect.yaml
で検知しないようにしておく。

以下にアクセスで試せる。
http://ローカルのIP:8080/quoridorn

## 容量を減らす。

### 環境変数でprodutctionモードに。

```docker-compose.yml
      - NODE_ENV=production
```


### ソースマップやgzipを出さない。

gzipはfirebaseでは不要。

vue.config.js

```
module.exports = {
 productionSourceMap: process.env.NODE_ENV === 'development',

...

  configureWebpack: {
    plugins: [
      // new CompressionWebpackPlugin({
      //   filename: "[path].gz[query]",
      //   algorithm: "gzip",
      //   test: new RegExp("\\.(" + productionGzipExtensions.join("|") + ")$"),
      //   threshold: 1024,
      //   minRatio: 0.8
      // })

```

### 容量の大きい音楽や画像を削除



