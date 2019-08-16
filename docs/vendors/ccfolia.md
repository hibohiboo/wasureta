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
