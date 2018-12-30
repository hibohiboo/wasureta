# NuxtでSPA作成

## プロジェクト作成

とりあえず、すべて空で作成。

```
bin/work/create-project.sh
```

[この時点のソース](https://github.com/hibohiboo/wasureta/tree/f002b395f9ee592fd8298afe0b0859592b3f5418)

## packageインストール

mypageを共有すると、windowsでエラーがでるので、必要なフォルダ・ファイルのみ共有。

### docker-compose.yml編集
yarn.lockファイルを空のファイルで作成して共有。
node_modules用のキャッシュを作成。

### 実行

```
bin/work/first-install-package.sh
```

無事に終了すると、yarn.lockファイルが上書きされている。

[この時点のソース](https://github.com/hibohiboo/wasureta/tree/420019fd9ef093cf27fca9f68673e16f6681fd80)
