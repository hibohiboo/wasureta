# Redux ExampleのTodo ListをはじめからていねいにVue.jsで。
## 概要
[Redux ExampleのTodo Listをはじめからていねいに][*1]をVue.js*Typescriptを使って行ったメモ。

## 環境

* Windows 10
* Vagrant 2.2.5
* virtualbox 6.0.10
* Ubuntu 18.04 LTS (Bionic Beaver)
* Docker version 18.09.5, build e8ff056
* docker-compose version 1.24.0, build 0aa59064

仮想環境のIPは192.168.50.10に指定。

ブラウザはchromeで確認。

## ディレクトリ構成(Hello world時)

* vue-cliで生成されるソースコードを参考としている。

```console
.
├── bin # docker-composeの操作をシェル化
│   ├── bash.sh # コンテナ内にbashでログイン
│   ├── build.sh # dist内にjsファイルをビルド
│   ├── container_build.sh # 作業用コンテナ作成
│   ├── fix.sh # lintによるソースコードの自動修正
│   └── up.sh # 開発サーバの起動
├── dist # ビルドされたファイルの格納先
├── docker
│   ├── config # コンテナ内にコピーされる設定ファイル
│   │   ├── .browserslistrc    # 対応ブラウザ設定
│   │   ├── .eslintrcjs        # lint設定
│   │   ├── cypress.json       # テストランナー設定
│   │   ├── jest.config.js     # テストツール設定
│   │   ├── package.json       # npm設定ファイル
│   │   ├── postcss.config.js  # postcss設定ファイル
│   │   ├── tsconfig.json      # typescript設定ファイル
│   │   └── vue.config.js      # webpack設定ファイル
│   ├── docker-compose.yml      # コンテナ起動時設定ファイル
│   └── vue
│       └── Dockerfile          # イメージ作成用のコマンド記述ファイル
├── public
│   ├── favicon.ico
│   └── index.html
├── src
│   ├── assets
│   │   └── logo.png
│   ├── components # Vueコンポーネント
│   │   └── HelloWorld.vue
│   ├── App.vue # Appコンポーネント
│   ├── main.ts # エントリーポイント
│   ├── shims-tsx.d.ts # 型定義ファイル
│   ├── shims-vue.d.ts # 型定義ファイル
│   └── types.d.ts # 型定義ファイル
├── tests
│   ├── e2e
│   │   ├── plugins
│   │   │   └── index.js
│   │   ├── specs
│   │   │   └── test.js
│   │   └── support
│   │       ├── commands.js
│   │       └── index.js
│   └── unit
│       └── example.spec.ts
└── .gitignore
```

### ビルドツール

```dockerfile:docker/vue/Dockerfile
FROM node:12.9.1

# コンテナ上の作業ディレクトリ作成
WORKDIR /app
#COPY ./* /app/
#RUN yarn install
RUN yarn add --dev \
  @babel/core \
  @babel/preset-env \
  babel-loader \
  css-loader \
  vue-loader \
  vue-style-loader \
  vue-template-compiler \
  webpack \
  webpack-cli \
  webpack-dev-server
RUN yarn add vue vue-custom-element
RUN npm install -g @vue/cli
RUN yarn add --dev typescript

RUN yarn add --dev ts-loader
RUN yarn add vue-class-component 
RUN yarn add vue-property-decorator
RUN yarn add --dev html-webpack-plugin
RUN yarn add --dev @types/jest
RUN yarn add --dev @vue/cli-plugin-e2e-cypress
RUN yarn add --dev @vue/cli-plugin-eslint
RUN yarn add --dev @vue/cli-plugin-typescript
RUN yarn add --dev @vue/cli-plugin-unit-jest
RUN yarn add --dev @vue/cli-service
RUN yarn add --dev @vue/eslint-config-airbnb
RUN yarn add --dev @vue/eslint-config-typescript
RUN yarn add --dev @vue/test-utils
RUN yarn add --dev babel-eslint
RUN yarn add --dev eslint
RUN yarn add --dev eslint-plugin-vue
RUN yarn add --dev ts-jest
RUN yarn add --dev typescript
RUN yarn add --dev vue-template-compiler

RUN yarn add --dev @types/firebase
RUN yarn add --dev vuex
```

```yaml:docker/docker-compose.yml
version: '3'
services:
  web_components_vue:
    build: ./vue
    ports:
      - 8080:8080
    volumes:
      - ../src:/app/src
      - ../public:/app/public
      - ../tests:/app/tests
      - ./config/.browserslistrc:/app/.browserslistrc
      - ./config/.eslintrc.js:/app/.eslintrc.js
      - ./config/cypress.json:/app/cypress.json
      - ./config/jest.config.js:/app/jest.config.js
      - ./config/package.json:/app/package.json
      - ./config/postcss.config.js:/app/postcss.config.js
      - ./config/tsconfig.json:/app/tsconfig.json
      - ./config/vue.config.js:/app/vue.config.js
      - ../dist:/dist
    command: [yarn, serve ]
```

```json:docker/config/package.json
{
  "name": "vue-typescript",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build && cp -r /app/dist/* /dist/",
    "lint": "vue-cli-service lint",
    "test:e2e": "vue-cli-service test:e2e",
    "test:unit": "vue-cli-service test:unit"
  },
  "dependencies": {
    "vue": "^2.6.10",
    "vue-class-component": "^7.1.0",
    "vue-property-decorator": "^8.2.2"
  },
  "devDependencies": {
    "@babel/core": "^7.5.5",
    "@babel/preset-env": "^7.5.5",
    "@types/jest": "^24.0.18",
    "@vue/cli-plugin-e2e-cypress": "^3.11.0",
    "@vue/cli-plugin-eslint": "^3.11.0",
    "@vue/cli-plugin-typescript": "^3.11.0",
    "@vue/cli-plugin-unit-jest": "^3.11.0",
    "@vue/cli-service": "^3.11.0",
    "@vue/eslint-config-airbnb": "^4.0.1",
    "@vue/eslint-config-typescript": "^4.0.0",
    "@vue/test-utils": "^1.0.0-beta.29",
    "babel-eslint": "^10.0.3",
    "babel-loader": "^8.0.6",
    "css-loader": "^3.2.0",
    "eslint": "^6.3.0",
    "eslint-plugin-vue": "^5.2.3",
    "html-webpack-plugin": "^3.2.0",
    "ts-jest": "^24.0.2",
    "ts-loader": "^6.0.4",
    "typescript": "^3.6.2",
    "vue-loader": "^15.7.1",
    "vue-style-loader": "^4.1.2",
    "vue-template-compiler": "^2.6.10",
    "webpack": "^4.39.3",
    "webpack-cli": "^3.3.7",
    "webpack-dev-server": "^3.8.0"
  }
}
```

```js:docker/config/vue.config.js
module.exports = {
  configureWebpack: {
    // ビルド高速化のために外部からvue.jsを読み込む
    externals: {
      vue: 'Vue',
    },
  },
  devServer: {
    // sock.js用に仮想環境のIPとポートを指定
    public: '192.168.50.10:8080',
    // vagrantの仕様でポーリングしないとファイルの変更を感知できない
    watchOptions: {
      poll: true,
    },
    disableHostCheck: true,
    hotOnly: true,
    clientLogLevel: 'warning',
    inline: true,
  },
};
```


```text:.browserslistrc
last 1 chrome version
```

```js:.eslintrc.js
module.exports = {
  root: true,
  env: {
    node: true,
  },
  extends: [
    'plugin:vue/essential',
    '@vue/airbnb',
    '@vue/typescript',
  ],
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'max-len': ['error', { code: 140 }],
    'import/extensions': 'off',
  },
  parserOptions: {
    parser: '@typescript-eslint/parser',
  },
  overrides: [
    {
      files: [
        '**/__tests__/*.{j,t}s?(x)',
      ],
      env: {
        jest: true,
      },
    },
  ],
};
```

```js:docker/config/postcss.config.js
module.exports = {
  plugins: {
    autoprefixer: {},
  },
};

```

```json:docker/config/tsconfig.json
{
  "compilerOptions": {
    "target": "es6",
    "module": "esnext",
    "strict": true,
    "jsx": "preserve",
    "importHelpers": true,
    "moduleResolution": "node",
    "experimentalDecorators": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "sourceMap": true,
    "baseUrl": ".",
    "types": [
      "webpack-env",
      "jest"
    ],
    "paths": {
      "@/*": [
        "src/*"
      ]
    },
    "lib": [
      "esnext",
      "dom",
      "dom.iterable",
      "scripthost"
    ]
  },
  "include": [
    "src/**/*.ts",
    "src/**/*.tsx",
    "src/**/*.vue",
    "tests/**/*.ts",
    "tests/**/*.tsx"
  ],
  "exclude": [
    "node_modules"
  ]
}
```


### 開発サーバ用html

開発サーバにはwebpack-dev-serverを利用する。

```html
<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>TodoList</title>
</head>

<body>
      <!-- vueのコンポーネントを#root以下に作成する設定にしている -->
      <div id="app"></div>
      <!-- vueを外部から読み込む -->
      <script src="https://cdn.jsdelivr.net/npm/vue"></script>
      <script src="https://unpkg.com/vuex@3.1.1/dist/vuex.js"></script>
</body>

</html>
```

### shell

docker-composeのコマンドを毎回タイプするのが面倒なのでシェルにしている。

```shell:bin/up.sh
#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$(cd $bin_dir/.. && pwd)
docker_dir=$(cd $parent_dir/docker && pwd)
composeFile=${1:-"docker-compose.yml"}

# docker-composeの起動
cd $docker_dir && docker-compose -f $composeFile up
```

```shell:bin/fix.sh
#!/bin/bash

bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$(cd $bin_dir/.. && pwd)
docker_dir=$(cd $parent_dir/docker && pwd)
container_name=${1:-web_components_vue}

# $container_nameの有無をgrepで調べる
docker ps | grep $container_name

# grepの戻り値$?の評価。 grep戻り値 0:一致した 1:一致しなかった
if [ $? -eq 0 ]; then
  # 一致したときの処理
  cd $docker_dir && docker-compose exec --env NODE_ENV=development $container_name yarn lint --fix
else
  # 一致しなかった時の処理
  # コンテナを立ち上げて接続
  cd $docker_dir && docker-compose run -e NODE_ENV=development $container_name yarn lint --fix
fi
```

```shell:bin/build.sh
#!/bin/bash

bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$(cd $bin_dir/.. && pwd)
docker_dir=$(cd $parent_dir/docker && pwd)
container_name=${1:-web_components_vue}

# 出力ディレクトリのクリーン
rm -rf $parent_dir/dist/js 

docker ps | grep $container_name
if [ $? -eq 0 ]; then
  cd $docker_dir && docker-compose exec --env NODE_ENV=production $container_name yarn build
else
  cd $docker_dir && docker-compose run -e NODE_ENV=production $container_name yarn build
fi
```

## 1. Hello world

```ts:src/main.ts
import Vue from 'vue';
import App from './App.vue';

new Vue({
  render: (h: (app: any) => Vue.VNode) => h(App),
}).$mount('#app');
```

```vue:src/App.vue
<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png" />
    <HelloWorld msg="Welcome to Your Vue.js + TypeScript App" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import HelloWorld from "./components/HelloWorld.vue";

@Component({
  components: {
    HelloWorld
  }
})
export default class App extends Vue {}
</script>

<style>
#app {
  text-align: center;
  margin-top: 60px;
}
</style>
```

```vue:src/components/HelloWorld.vue
<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";

@Component
export default class HelloWorld extends Vue {
  @Prop() private msg!: string;
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1 {
  margin: 40px 0 0;
}
</style>
```


### 実行

開発用サーバを起動。

```bash
./bin/up.sh
```
ブラウザでアクセスして確認。

http://192.168.50.10:8080/


[この時点のソース](https://github.com/hibohiboo/wasureta/tree/cd260d7aae50fff525bbd406d4d4e0167540b6f0/takuan/plugins/room)  


## 2. actionCreatorで発行したactionをreducerに渡してstoreのstateを更新する


## 参考

[Redux ExampleのTodo Listをはじめからていねいに][*1]
[Redux ExampleのTodo Listをはじめからていねいにtypescriptで][*2]
[MithrilのTodo Listをはじめからていねいに][*3]
[実践TypeScript][*4]
[webpackのビルド高速化の効果を測ってみた][*5]
[TypeScriptでVueを書く][*6]
[vue.js todo mvc][*7]
[vuex][*8]
[vue cli TypeScript のサポート][*9]

[*1]:https://qiita.com/xkumiyu/items/9dfe51d2bcb3bdb06da3
[*2]:https://qiita.com/hibohiboo/items/e344d2bbbaaab0ba8a66
[*3]:https://qiita.com/hibohiboo/items/7ae89f840302882cf1d3
[*4]:https://book.mynavi.jp/supportsite/detail/9784839969370.html
[*5]:https://qiita.com/wadahiro/items/345c255f4c23152bd972
[*6]:https://mae.chab.in/archives/60167
[*7]:https://jp.vuejs.org/v2/examples/todomvc.html
[*8]:https://vuex.vuejs.org/ja/guide/state.html
[*9]:https://jp.vuejs.org/v2/guide/typescript.html#%E5%9F%BA%E6%9C%AC%E7%9A%84%E3%81%AA%E4%BD%BF%E3%81%84%E6%96%B9