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


## 2. actionでcommitを呼び出してmutationでstateを更新する
Reduxの「2. actionCreatorで発行したactionをreducerに渡してstoreのstateを更新する」に該当する部分。

### Store

Reduxとほぼ同じ概念。
アプリケーションで単一のもので、stateを保持する。

* ストアの状態を直接変更することはできない。明示的にミューテーションをコミットすることによってのみ、ストアの状態を変更する。

```ts:src/store/index.ts
import Vue from 'vue';
import Vuex from 'vuex';

// ルートコンポーネントに store オプションを指定することですべての子コンポーネントにストアを注入。
Vue.use(Vuex);

// 各プロパティの詳細は後述

export default new Vuex.Store({
  state,
  mutations,
  getters,
  actions,
});
```


### State

ReduxでいうところのStore。
アプリケーションで単一のもので、state(状態)を保持する。

```ts:src/store/index.ts
export type TodoItem = {
  id: number;
  text: string;
}

export interface State {
  todos: TodoItem[];
}

// 状態管理用state
export const state: State = ({ todos: [] } as State);
```

### Getter
ストアの状態を算出したいときに使える。
例えば項目のリストをフィルタリングしたりカウントしたりできる。

```ts:src/store/index.ts
// getter関数の定義でプログラマが自由に決めることができるのは「関数名」と「戻り型」のみ。
interface IGetters {
  // 関数名:戻り型
  todos: TodoItem[];
  todosCount: number;
}

// getter関数の引数は固定のため、インデックスシグネチャを利用して全てのgetter関数にState型とgetter関数の型参照を定義
type Getters<S, G, RS = {}, RG = {}> = {
  // [K in keyof G]: 定義されている関数名を取得
  // G[K] ： 取得した戻り型を付与
  // RS,RG : 第三引数、第四引数については保留
  [K in keyof G]: (state: S, getters: G, rootState: RS, rootGetters: RG) => G[K]
}

// 値の取得
export const getters: Getters<State, IGetters> = {
  todos: () => state.todos,
  todosCount: () => state.todos.length,
};
```

### Mutation

実際に Vuex のストアの状態を変更できる唯一の方法。
ReduxだとReducerがやっている役割。

```ts:src/store/index.ts
// 状態の変化
export const ADD_TODO_TEXT = "ADD_TODO_TEXT";

// mutation関数の戻り値はvoidで固定。自由に決めることができるのは「関数名」と「payload」
interface IMutations {
  // 関数名:payloadの型
  [ADD_TODO_TEXT]: string;
}
type Mutations<S, M> = {
  [K in keyof M]: (state: S, payload: M[K]) => void
}

// Vuexのストアの状態を変更できる唯一の方法
export const mutations: Mutations<State, IMutations> = {
  // 定数を関数名として使用できる ES2015 の算出プロパティ名（computed property name）機能を使用
  [ADD_TODO_TEXT](state, text) {
    const todo = {
      id: 0,
      text
    };
    if (state.todos.length !== 0) {
      todo.id = state.todos[state.todos.length - 1].id + 1;
    }
    state.todos.push(todo);
  },
};
```

### Action

* アクションは、状態を変更するのではなく、ミューテーションをコミットする。
* アクションは任意の非同期処理を含むことができる。

```ts
// Actionはgetters・mutations・同じModuleの参照・Rootの参照を第一引数のcontextに持っている
interface IActions {
  // 関数名:payloadの型
  asyncSetTodoText: string;
}
// Actionsの戻り値は保留してanyに。async functionを指定でき、同期的に書いてもライブラリ中でPromiseとなるため、複雑になる。
type Actions<S, A, G = {}, M = {}, RS = {}, RG = {}> = {
  [K in keyof A]: (ctx: Context<S, A, G, M, RS, RG>, payload: A[K]) => any
}
type Context<S, A, G, M, RS, RG> = {
  commit: Commit<M>;
  dispatch: Dispatch<A>;
  state: S;
  getters: G;
  rootState: RS;
  rootGetters: RG;
}
// Mで渡ってくるIMutationのkeyofで定義されている関数名を特定する。
// keyof Mは '[ADD_TODO_TEXT]'
// 関数型直前に <T extends keyof M>と付与することでTはkeyof Mで定義されているいずれかしか入力できなくなる
// 第一引数に、これらいずれかの文字列が入力されたとき、第二引数の型がM[T]として確定する。
// Lookup Typesを利用して引数同士の関連付けを行っている。
type Commit<M> = <T extends keyof M>(type: T, payload?: M[T]) => void;
type Dispatch<A> = <T extends keyof A>(type: T, payload?: A[T]) => any;

// ミューテーションをコミットする。非同期処理を含むことができる。
export const actions: Actions<
  State,
  IActions,
  IGetters,
  IMutations
> = {
  asyncSetTodoText({ commit }, text) {
    commit(ADD_TODO_TEXT, text);
  },
};

```

### 実行

```ts:src/main.ts
import Vue from 'vue';
import App from './App.vue';
import store from './store'

store.dispatch('asyncSetTodoText', 'Hello World!');
store.dispatch('asyncSetTodoText', 'Hello World!!');

console.log('todos', store.getters.todos);
console.log('count', store.getters.todosCount);
new Vue({
  render: (h: (app: any) => Vue.VNode) => h(App),
}).$mount('#app');
```

ブラウザでアクセスして、consoleに表示されているか確認する。

[この時点のソース](https://github.com/hibohiboo/wasureta/tree/5664226c7d157c1490c84be8d77d44a8aace2b90/takuan/plugins/room)  

### 定義の整理

```ts:store/models/TodoItem.ts
export type TodoItem = {
  id: number;
  text: string;
};
```


```ts:store/types.ts
type Getters<S, G, RS = {}, RG = {}> = {
  [K in keyof G]: (state: S, getters: G, rootState: RS, rootGetters: RG) => G[K]
}
type Mutations<S, M> = {
  [K in keyof M]: (state: S, payload: M[K]) => void
}
type Commit<M> = <T extends keyof M>(type: T, payload?: M[T]) => void;
type Dispatch<A> = <T extends keyof A>(type: T, payload?: A[T]) => any;
type Context<S, A, G, M, RS, RG> = {
  commit: Commit<M>;
  dispatch: Dispatch<A>;
  state: S;
  getters: G;
  rootState: RS;
  rootGetters: RG;
}
type Actions<S, A, G = {}, M = {}, RS = {}, RG = {}> = {
  [K in keyof A]: (ctx: Context<S, A, G, M, RS, RG>, payload: A[K]) => any
}
```

```ts:store/todoTypes.ts
export interface State {
  todos: TodoItem[];
}
// getters向け、getter関数の戻り型を定義
export interface IGetters {
  todos: TodoItem[];
  todosCount: number;
}
export const ADD_TODO_TEXT = "ADD_TODO_TEXT";
// mutations向け、mutation関数のpayloadを定義
export interface IMutations {
  [ADD_TODO_TEXT]: string;
}
// actions向け、action関数のpayloadを定義
export interface IActions {
  asyncSetTodoItemText: string;
}
```

```ts:src/store/index.ts
import Vue from 'vue';
import Vuex from 'vuex';
import { Getters, Mutations, Actions } from './types';
import { State, IGetters, IMutations, IActions, ADD_TODO_TEXT } from './todoType';

Vue.use(Vuex);

const todoState: State = ({ todos: [] } as State);

const getters: Getters<State, IGetters> = {
  todos: (state) => state.todos,
  todosCount: (state) => state.todos.length,
};

const mutations: Mutations<State, IMutations> = {
  [ADD_TODO_TEXT](state, text) {
    const todo = {
      id: 0,
      text
    };
    if (state.todos.length !== 0) {
      todo.id = state.todos[state.todos.length - 1].id + 1;
    }
    state.todos.push(todo);
  },
};

const actions: Actions<
  State,
  IActions,
  IGetters,
  IMutations
> = {
  asyncSetTodoItemText({ commit }, text) {
    commit(ADD_TODO_TEXT, text);
  },
};

export default new Vuex.Store({
  state : todoState,
  mutations,
  getters,
  actions,
});
```
[この時点のソース](https://github.com/hibohiboo/wasureta/tree/70a2807d5eb5f23f7fa3125e4633fd9a02e17d57/takuan/plugins/room)  

## 3. storeで保持したstateをViewで表示する

ルートインスタンスに store オプションを渡すことで、渡されたストアをルートの全ての子コンポーネントに注入する。
これは this.$store で各コンポーネントから参照することができる。

```diff:src/main.ts
new Vue({
  render: (h: (app: any) => Vue.VNode) => h(App),
+  store,
}).$mount('#app');
```

### ToDoコンポーネントとToDoListコンポーネントを作る

Todoコンポーネントは、propとして渡されてきたtodoのtextを表示するだけ。

```vue:src/components/Todo.vue
<template>
  <li>{{text}}</li>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import { TodoItem } from "../models/TodoItem";

@Component
export default class Todo extends Vue {
  @Prop()
  public todo: TodoItem;
  get text() {
    return this.todo.text;
  }
}
</script>
```

TodoListコンポーネントは、todosの各要素をTodoコンポーネントに渡す。
ここで、配列としてコンポーネントを複数生成するときkeyが必要になる。

```vue:src/components/TodoList.vue
<template>
  <ul class="todos">
    <Todo v-for="todo in todos" :key="todo.id" :todo="todo" />
  </ul>
</template>
<script lang="ts">
import { Prop, Component, Vue, Emit } from "vue-property-decorator";
import Todo from "./Todo.vue";
import { TodoItem } from "../models/TodoItem";

@Component({ components: { Todo } })
export default class TodoList extends Vue {
  @Prop()
  public todos: TodoItem[];
}
</script>
```

### ブラウザに表示

Hellow Worldを表示させているだけのAppコンポーネントにTodoListコンポーネントを表示させる。
ここでstoreから値を取得してTodoListコンポーネントに与えている。

```ts:src/App.vue
<template>
  <div id="app">
    <TodoList :todos="todos" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import TodoList from "./components/TodoList.vue";

@Component({
  components: {
    TodoList
  }
})
export default class App extends Vue {
  get todos() {
    return this.$store.getters.todos;
  }
}
</script>
```

[この時点のソース](https://github.com/hibohiboo/wasureta/tree/7a644357181dfb6e755d0a8863b151fe93fffab4/takuan/plugins/room)  

## 4. フォームからtodoを追加

フォームからtodoを追加するために、AddTodoコンポーネントを作る。

```vue:src/components/AddTodo.vue
<template>
  <div>
    <input type="text" v-model="text" />
    <button @click="addTodo">Add Todo</button>
  </div>
</template>
<script lang="ts">
import { Prop, Component, Vue } from "vue-property-decorator";
@Component
export default class AddTodo extends Vue {
  @Prop({})
  public text: string;

  public addTodo() {
    this.$store.dispatch("asyncSetTodoText", this.text);
  }
}
</script>
```

AppコンポーネントにAddTodoコンポーネントを追加する。

```diff
<template>
  <div id="app">
    <AddTodo />
+    <TodoList :todos="todos" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import TodoList from "./components/TodoList.vue";
+ import AddTodo from "./components/AddTodo.vue";

@Component({
  components: {
    TodoList
+   AddTodo
  }
})
export default class App extends Vue {
  get todos() {
    return this.$store.getters.todos;
  }
}
</script>
```

[この時点のソース](https://github.com/hibohiboo/wasureta/tree/8b56225fb8367a8fa66b9a90376d0636111c3df4/takuan/plugins/room)  

## モジュール化

Vuexの機能でもう一つ、モジュールを使っていなかったので試してみる。
Vuex ではストアをモジュールに分割できるようになっている。

```diff:src/store/index.ts
- export default new Vuex.Store({
-    state: todoState,
-    mutations,
-    getters,
-    actions,
- });
+ const todoModule = {
+    namespaced: true,
+    state: todoState,
+    mutations,
+    getters,
+    actions,
+ }
+
+ export default new Vuex.Store({
+   modules: { todo: todoModule }
+ });
```

使う側では、名前空間を区切って使うようにする。

```diff:src/main.ts
-store.dispatch('asyncSetTodoText', 'Hello World!');
-store.dispatch('asyncSetTodoText', 'Hello World!!');
+store.dispatch('todo/asyncSetTodoText', 'Hello World!');
+store.dispatch('todo/asyncSetTodoText', 'Hello World!!');
console.log('todos', store.getters.todos);
console.log('count', store.getters.todosCount);
new Vue({
  render: (h: (app: any) => Vue.VNode) => h(App),
  store,
}).$mount('#app');
```

```diff:src/App.vue
 export default class App extends Vue {
   get todos() {
-    return this.$store.getters.todos;
+    return this.$store.getters["todo/todos"];
   }
```

```diff:src/components/AddTodo.vue
   public addTodo() {
-    this.$store.dispatch('asyncSetTodoText', this.text);
+    this.$store.dispatch("todo/asyncSetTodoText", this.text);
   }
```

[この時点のソース](https://github.com/hibohiboo/wasureta/tree/5dd2fb4a6765778f24bf3a377023b369e25330e8/takuan/plugins/room)  

### フォルダ整理

todoの定義をstore/todo/index.tsに移し替える。
todoTypes.tsもstore/todo/type.tsに合わせてリネーム。

```ts:src/store/index.ts
import Vue from 'vue';
import Vuex from 'vuex';
import todo from './todo';
// ルートコンポーネントに store オプションを指定することですべての子コンポーネントにストアを注入。
Vue.use(Vuex);

export default new Vuex.Store({
  modules: { todo },
});
```

```ts:store/todo/index.ts
import { Getters, Mutations, Actions } from '../types';
import {
  State, IGetters, IMutations, IActions, ADD_TODO_TEXT,
} from './types';


// 状態管理用state
const todoState: State = ({ todos: [] } as State);

// 値の取得
const getters: Getters<State, IGetters> = {
  todos: state => state.todos,
  todosCount: state => state.todos.length,
};

// Vuexのストアの状態を変更できる唯一の方法
const mutations: Mutations<State, IMutations> = {
  // 定数を関数名として使用できる ES2015 の算出プロパティ名（computed property name）機能を使用
  [ADD_TODO_TEXT](state, text) {
    const todo = {
      id: 0,
      text,
    };
    if (state.todos.length !== 0) {
      todo.id = state.todos[state.todos.length - 1].id + 1;
    }
    state.todos.push(todo);
  },
};

// ミューテーションをコミットする。非同期処理を含むことができる。
const actions: Actions<
  State,
  IActions,
  IGetters,
  IMutations
> = {
  asyncSetTodoText({ commit }, text) {
    commit(ADD_TODO_TEXT, text);
  },
};

export default {
  namespaced: true,
  state: todoState,
  mutations,
  getters,
  actions,
};
```

型定義ファイルをsrc/typesフォルダにまとめる。
また、vuexのStoreの拡張を行う。
vscodeで行ったが、定義後再起動しないと型が反映されないトラブルがあった。

```ts:src/types/shims-vuex.d.ts
import 'vuex';
import * as Todo from '../store/todo/types';

declare module 'vuex' {
  type Getters<S, G, RS = {}, RG = {}> = {
    [K in keyof G]: (state: S, getters: G, rootState: RS, rootGetters: RG) => G[K]
  }
  type Mutations<S, M> = {
    [K in keyof M]: (state: S, payload: M[K]) => void
  }
  type ExCommit<M> = <T extends keyof M>(type: T, payload?: M[T]) => void;
  type ExDispatch<A> = <T extends keyof A>(type: T, payload?: A[T]) => any;
  type ExActionContext<S, A, G, M, RS, RG> = {
    commit: ExCommit<M>;
    dispatch: ExDispatch<A>;
    state: S;
    getters: G;
    rootState: RS;
    rootGetters: RG;
  }
  type Actions<S, A, G = {}, M = {}, RS = {}, RG = {}> = {
    [K in keyof A]: (ctx: ExActionContext<S, A, G, M, RS, RG>, payload: A[K]) => any
  }
  type RootGetters = Todo.RootGetter; // 増えたら、& Hoge.RootGetter のように、Intersection Typesで連結していく。
  interface ExStore extends Store<{}> {
    // ここに拡張型を追加していく。
    getters: RootGetters
  }
}
```

```diff:src/App.vue
<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
+ import * as Vuex from 'vuex';
import TodoList from './components/TodoList.vue';
import AddTodo from './components/AddTodo.vue';

@Component({
  components: {
    TodoList,
    AddTodo,
  },
})
export default class App extends Vue {
+  $store!: Vuex.ExStore;

  get todos() {
    return this.$store.getters['todo/todos'];
  }
}
</script>
```


[この時点のソース](https://github.com/hibohiboo/wasureta/tree/43ba6c097aaeeffda595e3f4b626a3cbba506e70/takuan/plugins/room)  

## 次回
Todoの完了・未完了を切り替える「Toggle Todo」機能を実装。


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
[Vue + Vuex を使ってみた感想と、Redux との比較][*10]
[Vue.js と TypeScript で Todo リストアプリを実装した][*11]
[【Nuxt.js】Todoリストで理解するTypeScriptでVuex入門][*12]
[Vue.js+TypeScriptで外部APIを使ったTODOリストを作ってみた][*13]
[Vue.js + Vuexでデータが循環する全体像を図解してみた][*14]

[*1]:https://qiita.com/xkumiyu/items/9dfe51d2bcb3bdb06da3
[*2]:https://qiita.com/hibohiboo/items/e344d2bbbaaab0ba8a66
[*3]:https://qiita.com/hibohiboo/items/7ae89f840302882cf1d3
[*4]:https://book.mynavi.jp/supportsite/detail/9784839969370.html
[*5]:https://qiita.com/wadahiro/items/345c255f4c23152bd972
[*6]:https://mae.chab.in/archives/60167
[*7]:https://jp.vuejs.org/v2/examples/todomvc.html
[*8]:https://vuex.vuejs.org/ja/guide/state.html
[*9]:https://jp.vuejs.org/v2/guide/typescript.html#%E5%9F%BA%E6%9C%AC%E7%9A%84%E3%81%AA%E4%BD%BF%E3%81%84%E6%96%B9
[*10]:https://torounit.com/blog/2016/11/29/2495/
[*11]:https://qiita.com/Nossa/items/b2e38bea4bda87a1de12
[*12]:https://qiita.com/kawa64372358/items/7f84d8b1b765837ae9dd
[*13]:https://taisablog.com/archives/1669
[*14]:https://qiita.com/m_mitsuhide/items/f16d988ec491b7800ace

## 概要
1回目では、TodoをTodo Listに追加する「Add Todo」を作った。
今回は、Todoの完了・未完了を切り替える「Toggle Todo」の機能を作っていく。

[Redux ExampleのTodo ListをはじめからていねいにVue.jsで(1)][*2-1]

## ディレクトリ構成（Add Todo時）

```console
.
├── bin
│   ├── bash.sh
│   ├── build.sh
│   ├── container_build.sh
│   ├── fix.sh
│   └── up.sh
├── docker
│   ├── docker-compose.yml
│   ├── config
│   │   ├── cypress.json
│   │   ├── jest.config.js
│   │   ├── package.json
│   │   ├── postcss.config.js
│   │   └── vue.config.js
│   └── vue
│       └── Dockerfile
├── docs
│   ├── readme.md
│   └── todo.md
├── public
│   ├── favicon.ico
│   └── index.html
├── src
│   ├── main.ts
│   ├── App.vue
│   ├── assets
│   │   └── logo.png
│   ├── components
│   │   ├── AddTodo.vue
│   │   ├── HelloWorld.vue
│   │   ├── Todo.vue
│   │   └── TodoList.vue
│   ├── models
│   │   └── TodoItem.ts
│   ├── store
│   │   ├── index.ts
│   │   ├── todo
│   │   │   ├── index.ts
│   │   │   └── types.ts
│   │   └── types.ts
│   └── types
│       ├── shims-tsx.d.ts
│       ├── shims-vue.d.ts
│       ├── shims-vuex.d.ts
│       └── types.d.ts
├── tests
└── tsconfig.json
```

## 1. 完了・未完了を表すcompletedによってスタイルを変える

### todoにcompleted要素を追加して、とりあえず取り消し線を表示する

まず、todoごとに完了・未完了を区別するために、completedという要素を追加。

```diff:src/models/TodoItem.ts
export type TodoItem = {
  id: number;
  text: string;
+  completed: boolean;
};
```

前回つくったmutationを修正。
todo作成時は、未完了なので、デフォルトでfalseとする。


```diff:src/store/todo/index.ts
// Vuexのストアの状態を変更できる唯一の方法
const mutations: Mutations<State, IMutations> = {
  addTodoText(state, text) {
    const todo = {
      id: 0,
      text,
+      completed: false,
    };
    if (state.todos.length !== 0) {
      todo.id = state.todos[state.todos.length - 1].id + 1;
    }
    state.todos.push(todo);
  },
};
```

completedによってviewを変えるので、Todoコンポーネントを修正する。
completedがtrueだったらtextDecorationをline-throughとする。

```vue:src/components/Todo.vue
<template>
  <li 
+  v-bind:style="{ textDecoration: textDecoration }"
  >
    {{text}}
  </li>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import { TodoItem } from "../models/TodoItem";

@Component
export default class Todo extends Vue {
  @Prop()
  public todo: TodoItem;

  get text() {
    return this.todo.text;
  }

+  get textDecoration() {
+    return this.todo.completed ? "line-through" : "none";
+  }
}
</script>

```

これで、stateで保持されるtodoのcompletedがtrueのとき取り消し線がつく。
一時的にsrc/store/todo/index.tsのcompleted: falseをtrueに変えて動作確認をする。


[この時点のソース](https://github.com/hibohiboo/wasureta/tree/16fe695bd270ef99a84778ed8a75f67a8d0a74a4/takuan/plugins/room)  

### actionCreatorからcompleted要素を操作する
次に、action経由で取り消し線のON/OFFを行うために、actionCreatorとmutationの作成を行う。
必要となるのはidだけ。
addTodoTextとasyncSetTodoTextが長く感じてきたのでaddTodoに修正をついでに行った。

```diff:src/store/todo/types.ts
export interface IActions {
  addTodo: string;
+  toggleTodo: number;
}

export interface RootActions {
  'todo/addTodo': IActions['addTodo'];
+  'todo/toggleTodo': IActions['toggleTodo'];
}
```

```diff:src/store/todo/index.ts
const actions: Actions<
  State,
  IActions,
  IGetters,
  IMutations
> = {
  async addTodo({ commit }, text) {
    commit('addTodo', text);
  },
+  async toggleTodo({ commit }, id) {
+    commit('toggleTodo', id);
+  },
};
```

mutationではpayloadで受け取ったidのcompletedを反転させる。

```diff:src/store/todo/types.ts
export interface IMutations {
  addTodo: string;
+  toggleTodo: number;
}
export interface RootMutations {
  'todo/addTodo': IMutations['addTodo'];
+  'todo/toggleTodo': IMutations['toggleTodo'];
}
```

```diff:src/store/todo/index.ts
const mutations: Mutations<State, IMutations> = {
  addTodo(state, text) {
    const todo = {
      id: 0,
      text,
      completed: false,
    };
    if (state.todos.length !== 0) {
      todo.id = state.todos[state.todos.length - 1].id + 1;
    }
    state.todos.push(todo);
  },
+  toggleTodo(state, id) {
+    const target = state.todos.find(todo => todo.id === id);
+    if (target === undefined) {
+      throw new Error(`not found id:${id}`);
+    }
+    target.completed = !target.completed;
+  }
};
```

main.tsからtoggleTodoを使って動作確認。

```diff:src/main.ts
store.dispatch('todo/addTodo', 'Hello World!');
store.dispatch('todo/addTodo', 'Hello World!!');
+ store.dispatch('todo/toggleTodo', 0);

new Vue({
  render: (h: (app: any) => Vue.VNode) => h(App),
  store,
}).$mount('#app');
```

## 参考
[Redux ExampleのTodo ListをはじめからていねいにVue.jsで(1)][*2-1]
[Redux ExampleのTodo Listをはじめからていねいに(2)][*2-2]


[*2-1]:https://qiita.com/hibohiboo/items/e3030350ecc83cb2c3bc
[*2-2]:https://qiita.com/xkumiyu/items/e7e1e8ed6a5d6a6e20dd
