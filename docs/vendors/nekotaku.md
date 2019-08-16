# ねこ卓

## 保存先の変更
src\browser\backend\FirebaseBackend.tsの以下の部分にnekotaku/のプレフィクスをつけた。/nekotaku/id/nekotaku/idのパターンが出てしまったので、nekotakuを取ってからアクセスすることにした。
// TODO: できたらちゃんと直す。

```
    const formattedPath = path.replace('nekotaku', '');
    return this.database.ref(`nekotaku/${formattedPath}`);
```

また、firebase/database.rules.jsonも修正。
nekotaku/のプレフィックスを付けた。

```
{
  "rules": {
    "nekotaku": {
      "passwords": {
        "$roomId": {
          ".write": "auth.uid !== null && root.child('nekotaku/rooms/' + $roomId + '/canRemove').exists()",
```

## 設置ディレクトリの変更

src\browser\router.tsのbaseをnekotakuに変更。

```
export default new VueRouter({
  mode: 'history',
  base: 'nekotaku',
  routes,
});
```

### 画像ディレクトリの指定変更
4ファイルあった。
`src="/img/`を`src="/nekotaku/img/`へと置換。

## ファイルサイズの縮小

package.jsonのbrowserlistで最新のchromeのみ対応に。
  productionSourceMap: false,でソースマップを出さない。




