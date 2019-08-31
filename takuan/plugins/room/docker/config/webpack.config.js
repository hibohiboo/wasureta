const path = require('path');
const webpack = require('webpack');
const HTMLWebpackPlugin = require('html-webpack-plugin');


const MODE = process.env.npm_lifecycle_event === 'prod' ? 'production' : 'development';
const filename = MODE === 'production' ? '[name]-[hash].js' : '[name].js';

module.exports = {
  mode: 'production',
  entry: {
    index: './src/index.ts',
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: `${filename}`,
  },
  plugins: [
    new HTMLWebpackPlugin({
      template: 'src/index.html',
      inject: 'body',
      chunks: ['index'],
    }),
  ],
  resolve: {
    modules: [path.join(__dirname, 'src'), 'node_modules'],
    extensions: ['.js', '.vue', '.ts'],
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
        },
      },
      {
        test: /\.ts$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'babel-loader',
          },
          {
            loader: 'ts-loader',
          },
        ],
      },
      {
        test: /\.css$/,
        use: [
          "vue-style-loader",
          "css-loader",
        ],
      },
    ],
  },
  devServer: {
    hot: true,
    progress: true,
    inline: true,
    stats: 'errors-only',
    contentBase: path.join(__dirname, 'src'),
    historyApiFallback: true,
    host: '0.0.0.0',
    port: 8080
  },
  watch: true,
  watchOptions: {
    aggregateTimeout: 300,
    poll: 1000,
  },
  // cdnから読み込むものはここに
  externals: {
    vue: 'vue'
  },
};