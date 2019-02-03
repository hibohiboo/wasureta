const path = require('path');
const globule = require('globule');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const HTMLWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

const MODE = 'production';
const filename = MODE === 'production' ? '[name]-[hash].js' : 'index.js';

// ソース・出力先の設定
const opts = {
  src: path.join(__dirname, 'separate/pre-dist'),
  dest: path.join(__dirname, 'separate/dist'),
};

const files = {};
globule
  .find(['assets/**/*.js', '!assets/**/_*.js', '!assets/js/elm/**/*'], { cwd: opts.src })
  .forEach((findFileName) => {
    const key = findFileName.replace(new RegExp('.js$', 'i'), '');
    const value = path.join(opts.src, findFileName);
    files[key] = value;
  });

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
  // 共通で読み込むjsファイルを作成
  obj.chunks.push('css/style');
  obj.chunks.push('js/navigation');

  // assetsの相対パスを作成...できない。characters/などのディレクトリの下のものはバンドルされない
  const depth = obj.name.split(/\//g).length - 1;
  const assetsPath =  '../'.repeat(depth) + 'assets';
  const chunks = obj.chunks.map(s => `${assetsPath}/${s}`);

  return new HTMLWebpackPlugin({
    filename: `${obj.name}.html`,
    template: path.join(opts.src, `templates/${obj.name}.html`),
    chunks,
  });
});

module.exports = {
  mode: MODE,
  context: opts.src,
  entry: files,
  output: {
    path: opts.dest,
    publicPath: '',
    filename,
  },
  plugins: [
    ...htmlWebpackPlugins,
    new CleanWebpackPlugin([opts.dest], {
      root: __dirname,
      exclude: [],
      verbose: true,
      dry: false,
    }),
    // new CopyWebpackPlugin([
    //   {
    //     from: path.join(opts.src, 'assets'),
    //   },
    // ]),
    new MiniCssExtractPlugin({
      filename: '[name]-[hash].css',
      chunkFilename: 'assets/css/[id].css',
    }),
  ],
  resolve: {
    modules: [opts.src, 'node_modules'],
    extensions: ['.js', '.css', '.png'],
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
      // {
      //   test: /\.css$/,
      //   exclude: [/elm-stuff/, /node_modules/],
      //   loaders: [
      //     MiniCssExtractPlugin.loader,
      //     {
      //       loader: 'css-loader',
      //       options: {
      //         sourceMap: false,
      //         url: false,
      //       },
      //     },
      //   ],
      // },
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
    jquery: 'jQuery',
    firebase: 'firebase',
    firebaseui: 'firebaseui',
    vue: 'Vue',
    'chart.js': 'Chart',
  },
};
