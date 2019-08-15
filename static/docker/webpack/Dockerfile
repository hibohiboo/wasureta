FROM node:12.8.0

# コンテナ上の作業ディレクトリ作成
WORKDIR /app

# 後で確認出来るようにpackage.jsonを作成
RUN npm init -y

## for css
### sass
RUN yarn add --dev node-sass

### postcss
RUN yarn add --dev postcss postcss-cli
RUN yarn add --dev autoprefixer

### lint
RUN yarn add --dev stylelint 
RUN yarn add --dev stylelint-scss
RUN yarn add --dev stylelint-order
RUN yarn add --dev stylelint-config-sass-guidelines

## webpackインストール
RUN yarn add --dev webpack
RUN yarn add --dev webpack-cli
RUN yarn add --dev webpack-merge
RUN yarn add --dev webpack-dev-server

## plugin
RUN yarn add --dev mini-css-extract-plugin
RUN yarn add --dev html-minifier-webpack-plugin
RUN yarn add --dev clean-webpack-plugin
RUN yarn add --dev copy-webpack-plugin

### loaders
RUN yarn add --dev babel-loader
RUN yarn add --dev file-loader
RUN yarn add --dev style-loader
RUN yarn add --dev css-loader
RUN yarn add -D html-loader

## pug
RUN yarn add --dev pug
RUN yarn add --dev pug-cli#master
RUN yarn add --dev https://github.com/pugjs/pug-cli.git

## watch
RUN yarn add --dev chokidar
RUN yarn add --dev chokidar-cli

## script

### pug
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"pug\": \"pug -o \/app\/dist -P \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"build-pug\": \"pug \/app\/src -o \/app\/dist \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"watch\": \"chokidar '\/app\/**\/*.pug' -p -c 'npm run build-pug' \",/g" /app/package.json

RUN yarn add --dev cssnano
RUN yarn add --dev globule
RUN yarn add --dev html-webpack-plugin

RUN yarn add --dev cpx