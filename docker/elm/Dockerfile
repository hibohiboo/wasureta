FROM node:10.9.0

# コンテナ上の作業ディレクトリ作成
WORKDIR /app

# 後で確認出来るようにpackage.jsonを作成
RUN npm init -y

RUN yarn add elm
RUN yarn add elm-format
COPY ./elm.json elm.json
