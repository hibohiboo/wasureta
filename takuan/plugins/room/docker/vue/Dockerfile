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
