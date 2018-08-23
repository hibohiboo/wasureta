FROM node:10.9.0

# コンテナ上の作業ディレクトリ作成
WORKDIR /app

# 後で確認出来るようにpackage.jsonを作成
RUN npm init -y

# typescript
RUN yarn add --dev typescript

# tslint
RUN yarn add --dev tslint
RUN yarn add --dev tslint-config-airbnb

# typedoc
RUN yarn add --dev typedoc 

# ビルドツール
RUN yarn add --dev webpack
RUN yarn add --dev webpack-cli
RUN yarn add --dev copy-webpack-plugin
RUN yarn add --dev mini-css-extract-plugin
RUN yarn add --dev extract-text-webpack-plugin@next
# 開発用サーバ
RUN yarn add --dev webpack-dev-server

# es6用トランスパイラ
RUN yarn add --dev babel-loader
RUN yarn add --dev babel-core
RUN yarn add --dev babel-cli
RUN yarn add --dev babel-preset-es2015
RUN yarn add --dev babel-preset-env
RUN yarn add --dev babel-plugin-transform-react-jsx
# async
RUN yarn add --dev babel-preset-es2017
# babelのreact用preset
RUN yarn add --dev babel-preset-react

# webpack用typescript loader
RUN yarn add --dev ts-loader
RUN yarn add --dev apply-loader
RUN yarn add --dev pug-loader
RUN yarn add --dev css-loader
RUN yarn add --dev postcss-loader
RUN yarn add --dev sass-loader

# babel plugin
RUN yarn add  babel-polyfill

# 国際対応
RUN yarn add  i18next

# ブラウザを識別して自動で国際対応
RUN yarn add  i18next-browser-languagedetector

# JSON-loader
RUN yarn add --dev json-loader
RUN yarn add --dev yaml-loader

# ライブラリ追加
RUN yarn add  lodash
RUN yarn add  eventemitter3
RUN yarn add  firebase
RUN yarn add globule

# 追加: (後で移動)
RUN yarn add  webpack-serve
RUN yarn add  node-sass
RUN yarn add  autoprefixer
RUN yarn add --dev pug

RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"tslint\": \"tslint -p 'tsconfig.json'\",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"tsc\": \"tsc -p tsconfig.json \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"babel\": \"babel\",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"typedoc\": \"typedoc\",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"webpack\": \"webpack\",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"dev-server\": \"webpack-serve --open\", /g" /app/package.json
