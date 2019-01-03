const path = require('path');
const globule = require('globule');
const merge = require('webpack-merge');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const HTMLWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');

const MODE = process.env.NODE_ENV === 'production' ? 'production' : 'development';
let filename = '[name].js';
if (MODE === 'production') {
  filename = '[name]-[hash].js';
}

// ソース・出力先の設定
const opts = {
  src: path.join(__dirname, 'src'),
  dest: path.join(__dirname, 'dist'),
};
const files = {};
globule
  .find(['assets/**/*.js', '!assets/**/_*.js', '!assets/**/elm/*'], { cwd: opts.src })
  .forEach((findFileName) => {
    const key = findFileName.replace(new RegExp('.js$', 'i'), '');
    const value = path.join(opts.src, findFileName);
    files[key] = value;
  });

const htmlWebpackPlugins = [
  {
    name: 'index',
    chunks: [],
  }
].map((obj) => {
  obj.chunks.push('css/style');
  obj.chunks.push('js/navigation');

  const chunks = obj.chunks.map(s => `assets/${s}`);

  return new HTMLWebpackPlugin({
    filename: `go-waste/${obj.name}.html`,
    template: `/app/src/html/${obj.name}.html`,
    chunks,
  });
});

const common = {
  mode: MODE,
  context: opts.src,
  entry: files,
  output: {
    path: opts.dest,
    filename,
  },
  resolve: {
    modules: [opts.src, 'node_modules'],
    extensions: ['.js'],
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: { loader: 'babel-loader' },
      },
    ],
  },
  plugins: [...htmlWebpackPlugins],
  // cdnから読み込むものはここに
  externals: {
    jquery: 'jQuery',
    firebase: 'firebase',
    firebaseui: 'firebaseui',
    vue: 'Vue',
    'chart.js': 'Chart',
  },
};

if (MODE === 'production') {
  console.log('Building for Production...');

  // commonとマージ
  module.exports = merge(common, {
    optimization: {
      minimize: true,
    },
    plugins: [
      new CleanWebpackPlugin(['dist'], {
        root: __dirname,
        exclude: [],
        verbose: true,
        dry: false,
      }),
      new CopyWebpackPlugin(
        [{ from: '', to: './' }],
        { context: 'html' },
      ),
      new MiniCssExtractPlugin({
        filename: '/assets/css/[name].css',
        chunkFilename: '/assets/css/[id].css',
      }),
    ],
    module: {
      rules: [
        {
          test: /\.css$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            {
              loader: MiniCssExtractPlugin.loader,
            },
            {
              loader: 'css-loader',
              options: {
                url: false,
                minimize: true,
              },
            },
          ],
        },
      ],
    },
  });
}


if (MODE === 'development') {
  console.log('Building for dev...');
  module.exports = merge(common, {
    plugins: [
      new webpack.NamedModulesPlugin(),
      new webpack.NoEmitOnErrorsPlugin(),
    ],
    module: {
      rules: [
        {
          test: /\.css$/,
          exclude: [/node_modules/],
          loaders: ['style-loader', 'css-loader'],
        }],
    },
    // 開発サーバの設定
    devServer: {
    // // public/index.htmlをデフォルトのホームとする
      contentBase: './dist',
      // // バンドルしたファイルを/assets/js/フォルダに出力したものとする。
      // publicPath: "/assets/",
      // インラインモード
      inline: true,
      // 8080番ポートで起動
      port: 8080,
      // dockerのコンテナ上でサーバを動かすときは以下の設定で全ての接続を受け入れる
      host: '0.0.0.0',
      // hot loadを有効にする
      hot: true,
      // ログレベルをinfoに
      clientLogLevel: 'info',
    },
    // vagrantの仕様でポーリングしないとファイルの変更を感知できない
    watchOptions: {
      aggregateTimeout: 300,
      // ５秒毎にポーリング
      poll: 5000,
    },
  });
}
