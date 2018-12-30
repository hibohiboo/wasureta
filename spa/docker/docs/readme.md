# NuxtでSPA作成

## プロジェクト作成

とりあえず、すべて空で作成。

```
bin/work/create-project.sh
```

[この時点のソース](https://github.com/hibohiboo/wasureta/tree/f002b395f9ee592fd8298afe0b0859592b3f5418/spa)

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

[この時点のソース](https://github.com/hibohiboo/wasureta/tree/fd5f815a48e4415a6d5a508a7af26867b4b09eaa/spa)

## 起動

### docker-compose.yml編集

* dockerを使っているため、ワイルドカード IP アドレスで起動する.環境変数に`HOST=0.0.0.0`を設定
* portを開ける
* 作業ディレクトリで実行させる

```
    environment:
      - HOST=0.0.0.0
    working_dir: "/app/src/mypage"
    command: [yarn, dev]
    ports:
      - 3000:3000
```

### 実行

```
bin/up.sh
```

ポート3000でアクセスして、表示確認。


