FROM node:10.12.0

# コンテナ上の作業ディレクトリ作成
WORKDIR /app

# 後で確認出来るようにpackage.jsonを作成
RUN npm init -y

# dev-dependencies

## webpackインストール
RUN yarn add --dev webpack
RUN yarn add --dev webpack-cli
RUN yarn add --dev webpack-merge
RUN yarn add --dev webpack-serve
### 「History APIを利用して作成されるSPAのためのindexページをプロキシする」ミドルウェア
RUN yarn add --dev koa-connect-history-api-fallback
### plugins
RUN yarn add --dev html-webpack-plugin
RUN yarn add --dev mini-css-extract-plugin
RUN yarn add --dev clean-webpack-plugin
RUN yarn add --dev copy-webpack-plugin

## babelインストール
RUN yarn add --dev @babel/core
RUN yarn add --dev @babel/preset-env
RUN yarn add --dev babel-loader
## sass
RUN yarn add --dev node-sass
RUN yarn add --dev autoprefixer

## elmインストール
RUN yarn add --dev elm
RUN yarn add --dev elm-verify-examples
RUN yarn add --dev elm-format
# typescript
RUN yarn add --dev typescript
RUN yarn add --dev tslint
RUN yarn add --dev tslint-config-airbnb
RUN yarn add --dev typedoc 

### loaders
RUN yarn add --dev file-loader
RUN yarn add --dev url-loader
RUN yarn add --dev resolve-url-loader
RUN yarn add --dev css-loader
RUN yarn add --dev style-loader
RUN yarn add --dev sass-loader
RUN yarn add --dev postcss-loader
RUN yarn add --dev elm-hot-webpack-loader
RUN yarn add --dev elm-webpack-loader
RUN yarn add --dev ts-loader
RUN yarn add --dev json-loader
RUN yarn add --dev yaml-loader

RUN yarn add --dev lodash
RUN yarn add --dev eventemitter3
RUN yarn add --dev globule

# dependencies
RUN yarn add purecss
RUN yarn add firebase
RUN yarn add materialize-css@next
RUN yarn add firebaseui
RUN yarn add vue
RUN yarn add chart.js

RUN yarn add --dev @types/jquery
RUN yarn add --dev @types/materialize-css


# package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"prod\": \"webpack -p\"/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"build\": \"webpack\",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"dev\": \"webpack-serve --port 3000\",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"start\": \"yarn run dev --host 0.0.0.0\",/g" /app/package.json
RUN sed -i -e "/test/d"  /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"test\": \"elm-test\",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"tslint\": \"tslint -p 'tsconfig.json'\",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"tsc\": \"tsc -p tsconfig.json \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"babel\": \"babel\",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"typedoc\": \"typedoc\",/g" /app/package.json
