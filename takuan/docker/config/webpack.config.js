const path = require('path');
const webpack = require('webpack');
const merge = require('webpack-merge');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const HTMLWebpackPlugin = require('html-webpack-plugin');

// process.env.npm_lifecycle_event : webpackコマンドを実行したnpm script名が格納されている。
const MODE = process.env.npm_lifecycle_event === 'prod' ? 'production' : 'development';
const filename = MODE === 'production' ? '[name]-[hash].js' : '[name].js';


const common = {
  mode: MODE,
  entry: {
    index: './src/assets/js/index.ts',
    // scenario: './src/scenario/assets/js/index.ts'
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: `${filename}`,
  },
  plugins: [
    new HTMLWebpackPlugin({
      template: 'src/index.pug',
      inject: 'body',
      chunks: ['index'],
    }),
  ],
  resolve: {
    modules: [path.join(__dirname, 'src'), 'node_modules'],
    extensions: ['.js', '.elm', '.scss', '.png', '.ts', '.pug'],
  },
  module: {
    rules: [
      {
        test: /\.pug$/,
        use: [{
          loader: 'pug-loader',
        }],
      },
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
        test: /\.scss$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: ['style-loader', 'css-loader?url=false', 'sass-loader'],
      },
      {
        test: /\.css$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: ['style-loader', 'css-loader?url=false'],
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'url-loader',
        options: {
          limit: 10000,
          mimetype: 'application/font-woff',
        },
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'file-loader',
      },
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'file-loader',
      },
    ],
  },
  // cdnから読み込むものはここに
  externals: {
    jquery: 'jQuery'
    , 'chart.js': 'Chart'
    , firebase: 'firebase'
    , firebaseui: 'firebaseui'
    , moment: 'moment'
  },
};

if (MODE === 'development') {
  console.log('Building for dev...');
  module.exports = merge(common, {
    plugins: [
      new webpack.NamedModulesPlugin()
      , new webpack.NoEmitOnErrorsPlugin()
      , new webpack.DefinePlugin({
        REPRACE_TEST: JSON.stringify(process.env.REPRACE_TEST)
      })
    ],
    module: {
      rules: [
      ],
    },
    devServer: {
      hot: true,
      progress: true,
      inline: true,
      stats: 'errors-only',
      contentBase: path.join(__dirname, 'src'),
      historyApiFallback: true,
      before(app) {
        app.get('/test', (req, res) => {
          res.json({ result: 'OK' });
        });
      }
    },
    watch: true,
    watchOptions: {
      aggregateTimeout: 300,
      poll: 1000,
    },
  });
}
