const path = require('path')
const globule = require('globule')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

// Dependencies
// yarn add apply-loader autoprefixer babel-core babel-loader babel-preset-env css-loader copy-webpack-plugin extract-text-webpack-plugin@next globule node-sass postcss-loader pug pug-loader raw-loader sass-loader webpack webpack-cli webpack-serve

const opts = {
  src: path.join(__dirname, 'src'),
  dest: path.join(__dirname, 'dist')
}

const extensionConversions = {
  // pug: 'html',
  sass: 'css',
  js: 'js',
  ts: 'js'
}

const files = {}
Object.keys(extensionConversions).forEach(from => {
  const to = extensionConversions[from]
  globule.find([`assets/**/*.${from}`, `!assets/**/_*.${from}`], {cwd: opts.src}).forEach(filename => {
    files[filename.replace(new RegExp(`.${from}$`, 'i'), `.${to}`)] = path.join(opts.src, filename)
  })
})

const pugLoader = {
  use:[
    'apply-loader',
    'pug-loader'
  ]
};

const sassLoader = [
  {
    loader: 'css-loader',
    options: {
      minimize: true
    }
  },
  {
    loader: 'postcss-loader',
    options: {
      ident: 'postcss',
      plugins: (loader) => [require('autoprefixer')()]
    }
  },
  'sass-loader'
]

const jsLoader = {
  loader: 'babel-loader',
  query: {
    presets: ['env']
  }
}

module.exports = {
  context: opts.src,
  entry: files,
  output: {
    filename: '[name]',
    path: opts.dest
  },
  mode: process.env.ENV ? 'development' : 'production',
  module: {
    rules: [
      // {
      //   test: /\.pug$/,
      //   use: ExtractTextPlugin.extract(pugLoader),
      //   // use: [{
      //   //   loader: 'apply-loader'
      //   // }, {
      //   //   loader: 'pug-loader',
      //   //   options: { pretty: true }
      //   // }]
      // },
      {
        test: /\.ts$/,
        use: 'ts-loader'
      },
      {
        test: /\.sass$/,
        oneOf: [
          {
            resourceQuery: /inline/,
            use: sassLoader
          },
          {
            use: ExtractTextPlugin.extract(sassLoader)
          }
        ]
      },
      {
        test: /\.js$/,
        exclude: /node_modules(?!\/webpack-dev-server)/,
        oneOf: [
          {
            resourceQuery: /inline/,
            use: [
              'raw-loader',
              jsLoader
            ]
          },
          {
            use: jsLoader
          }
        ]
      }
    ]
  },
  externals: {
    jquery: 'jQuery'
  },
  plugins: [
    new ExtractTextPlugin('[name]'),
    new CopyWebpackPlugin(
      [{from: {glob: 'assets/**/*', dot: true}}],
      {ignore: Object.keys(extensionConversions).map((ext) => `*.${ext}`)}
    )
  ],
  serve: {
    content: opts.dest,
    // dockerのコンテナ上でサーバを動かすときは以下の設定で全ての接続を受け入れる
    host:"0.0.0.0",
    port: 8000, 
    open: true
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
    host:"0.0.0.0",
    // hot loadを有効にする
    hot: true,
    // ログレベルをinfoに
    clientLogLevel: "info",
  },
  // vagrantの仕様でポーリングしないとファイルの変更を感知できない
  watchOptions: {
    aggregateTimeout: 300,
    // ５秒毎にポーリング
    poll: 5000
  }
}