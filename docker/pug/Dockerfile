FROM node:11.1.0

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
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"build-pug\": \"npm run build-pug:index \&\& npm run build-pug:characters \&\& npm run build-pug:scenarios \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"build-pug:index\": \"pug -o \/app\/dist -P \/app\/src\/*.pug \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"build-pug:characters\": \"pug -o \/app\/dist\/characters -P \/app\/src\/characters\/*.pug \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"build-pug:scenarios\": \"pug -o \/app\/dist\/scenarios -P \/app\/src\/scenarios\/*.pug \",/g" /app/package.json
RUN sed -i -e "s/\(\"scripts\": {\)/\1\n    \"watch\": \"chokidar '\/app\/**\/*.pug' -p -c 'npm run build-pug' \",/g" /app/package.json

