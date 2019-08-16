## 変更

45403c69c64f3d8e4313c1e3fd633ff2e8ea076cのコミットで、firestoreの保存先を変更。
chattools/ccfolia/以下にデータを保存するようにした。

## firebase.jsの設定
src/config/firebase.jsを作成

## corsの設定
gsutilをbashでコンテナ内でインストールした。

https://cloud.google.com/storage/docs/gsutil_install?hl=ja#linux

コマンドは 以下。

```
curl https://sdk.cloud.google.com | bash
source /root/.bashrc
gsutil cors set cors.json  gs://{バケット名}
```

## サブディレクトリの設定

domain/ccfoliaに設置したい。
通常ではdomain直下を想定した設定のため、修正する。


package.jsonに   "homepage": "/ccfolia",  を追加。
src/containers/Home/RoomListitem.jsのhrefを/room/${props.roomId}から/ccfolia/room/${props.roomId}に変更
src/stores/index.jsのcreateBrowserHistory();をcreateBrowserHistory({ basename: '/ccfolia' });に変更

## この時のソース

[ソース](https://github.com/hibohiboo/ccfolia/tree/d9f2af9328dd5bf82ea5870c10eda94c8438b292)  
