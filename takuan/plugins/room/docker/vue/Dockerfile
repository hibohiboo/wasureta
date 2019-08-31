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