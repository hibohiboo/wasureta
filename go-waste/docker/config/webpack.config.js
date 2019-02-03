const path = require('path');
const globule = require('globule');
const merge = require('webpack-merge');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const HTMLWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');

const MODE = 'development'; //process.env.NODE_ENV === 'production' ? 'production' : 'development';
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
  .find(['assets/**/*.scss', 'assets/**/*.ts', '!assets/**/_*', '!assets/**/elm/*'], { cwd: opts.src })
  .forEach((findFileName) => {
    const key = findFileName.replace(new RegExp('.ts$', 'i'), '');
    const value = path.join(opts.src, findFileName);
    files[key] = value;
  });
console.log(opts.src)
// cssをhtml-webpack-pluginのchunks機能を使って埋め込み
const regJs = new RegExp('.js$', 'i');
const regCss = new RegExp('.css$', 'i');

const htmlWebpackPlugins = [
  {
    name: 'index',
    chunks: [],
  },
  {
    name: 'about',
    chunks: [],
  },
  {
    name: 'agreement',
    chunks: [],
  },
  {
    name: 'privacy-policy',
    chunks: [],
  },
  {
    name: 'rulebook',
    chunks: [],
  },
  {
    name: 'rulebook',
    chunks: [],
  },
  {
    name: 'sign-in',
    chunks: [],
  },
  {
    name: 'characters/index',
    chunks: [],
  },
  {
    name: 'characters/add',
    chunks: ['js/characters/edit'],
  },
  {
    name: 'characters/view',
    chunks: ['js/characters/view'],
  },
  {
    name: 'scenarios/sample1',
    chunks: [],
  },
].map((obj) => {
  obj.chunks.push('css/style');
  obj.chunks.push('js/navigation');
  const assetsPath =  'assets';
  const chunks = obj.chunks.map(s => `${assetsPath}/${s}`);

  return new HTMLWebpackPlugin({
    filename: `go-waste/${obj.name}.html`,
    template: path.join(opts.src, `templates/${obj.name}.pug`),
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
        test: /\.ts$/,
        use:  ['ts-loader']
      },
      {
        test: /\.pug$/,
        use:  ['html-loader?attrs=false','pug-html-loader?pretty&exports=false']
      },
      {
        test: /\.scss$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          { loader: 'style-loader' },
          { loader: 'css-loader',
            options: {
              url: false,
              modules: true
            }
          },
          {
            loader: 'postcss-loader',
            options: {
              ident: 'postcss',
              plugins: (loader) => [require('autoprefixer')()]
            }
          },
          { loader: 'sass-loader',
            options: {
              sourceMap: true
            }
          }
        ]
      }, 
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          { loader: 'elm-hot-webpack-loader' },
          { loader: "elm-webpack-loader",
            options: { debug: true, forceWatch: true }
          }
        ]
      }
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

if (MODE === 'development') {
  console.log('Building for dev...');
  module.exports = merge(common, {
    plugins: [
      new webpack.NamedModulesPlugin(),
      new webpack.NoEmitOnErrorsPlugin(),
    ],
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
