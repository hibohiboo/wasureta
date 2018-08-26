FROM node:10.9.0

# コンテナ上の作業ディレクトリ作成
WORKDIR /app

# 後で確認出来るようにpackage.jsonを作成
RUN npm init -y

RUN yarn add --dev pug

RUN yarn add --dev pug-cli

RUN yarn add --dev chokidar

RUN yarn add --dev chokidar-cli
RUN yarn add --dev https://github.com/pugjs/pug-cli.git

RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"pug\": \"pug -o \/app\/dist -P \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"build-pug\": \"npm run build-pug:index \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"build-pug:index\": \"pug -o \/app\/dist -P \/app\/src\/*.pug \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"watch\": \"chokidar '\/app\/src\/*.pug' -p -c 'npm run build-pug' \",/g" /app/package.json
