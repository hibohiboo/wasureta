const path = require("path");
const globule = require('globule')
const webpack = require("webpack");
const merge = require("webpack-merge");
const history = require('koa-connect-history-api-fallback');
const CopyWebpackPlugin = require("copy-webpack-plugin");
const HTMLWebpackPlugin = require("html-webpack-plugin");
const CleanWebpackPlugin = require("clean-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

var MODE = process.env.npm_lifecycle_event === "prod" ? "production" : "development";
const filename = MODE == "production" ? "[name]-[hash].js" : "[name].js";
//const files = {index:"./src/index.js", card:"./src/card.js"};

const opts = {
  src: path.join(__dirname, 'src'),
  dest: path.join(__dirname, 'dist')
}

const extensionConversions = {
  sass: 'css',
  js: 'js',
  ts: 'js',
  elm: 'js'
}

const files = {}
Object.keys(extensionConversions)
  .forEach(from => {
    const to = extensionConversions[from]
    globule
    .find([`assets/**/*.${from}`, `!assets/**/_*.${from}`, `!assets/**/*.elm`], {cwd: opts.src})
    .forEach(filename => {
      const key = filename.replace(new RegExp(`.${from}$`, 'i'), `.${to}`)
      const value = path.join(opts.src, filename)
      files[key] = value
      console.log(key, value)
    })
})

const postCssLoader = {
  loader: 'postcss-loader',
  options: {
    ident: 'postcss',
    plugins: (loader) => [require('autoprefixer')()]
  }
};

var common = {
    mode: MODE,
    context: opts.src,
    entry: files,
    output: {
        path: opts.dest,
        filename: filename
    },
    plugins: [
    ],
    resolve: {
        modules: [path.join(__dirname, "src"), "node_modules"],
        extensions: [ ".ts",".js", ".elm", ".sass", ".png", ".json"]
    },
    module: {
        rules: [

            {
              test: /\.ts$/,
              use: 'ts-loader'
            },
            {
              test: /\.js$/,
              exclude: /node_modules/,
              use: {
                  loader: "babel-loader"
              }
          },
            {
                test: /\.sass$/,
                exclude: [/elm-stuff/, /node_modules/],
                loaders: ["style-loader", "css-loader", postCssLoader, "sass-loader"]
            },
            {
                test: /\.css$/,
                exclude: [/elm-stuff/, /node_modules/],
                loaders: ["style-loader", "css-loader"]
            },
            {
                test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: "url-loader",
                options: {
                    limit: 10000,
                    mimetype: "application/font-woff"
                }
            },
            {
                test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: "file-loader"
            },
            {
                test: /\.(jpe?g|png|gif|svg)$/i,
                loader: "file-loader"
            }
        ]
    },
  // cdnから読み込むものはここに
  externals: {
    jquery: 'jQuery',
    firebase: 'firebase',
    firebaseui: 'firebaseui',
    vue: 'Vue',
    chartjs: "Chart"
  },
};

if (MODE === "development") {
    console.log("Building for dev...");
    module.exports = merge(common, {
        plugins: [
            new webpack.NamedModulesPlugin(),
            new webpack.NoEmitOnErrorsPlugin()
        ],
        module: {
            rules: [
                {
                    test: /\.elm$/,
                    exclude: [/elm-stuff/, /node_modules/],
                    use: [
                        { loader: 'elm-hot-webpack-loader' },
                        {
                            loader: "elm-webpack-loader",
                            options: {
                                debug: true,
                                forceWatch: true,
                            }
                        }
                    ]
                }
            ]
        },
        serve: {
            inline: true,
            stats: "errors-only",
            content: [path.join(__dirname, "src/assets")],
            add: (app, middleware, options) => {
                // routes /xyz -> /index.html
                app.use(history());
                // e.g.
                // app.use(convert(proxy('/api', { target: 'http://localhost:5000' })));
            },
            devMiddleware: {
              watch:true, 
              watchOptions:{
                aggregateTimeout: 300,
                poll:1000
              }
            },
            hotClient:{
              host: {
                client: '192.168.50.10', // 仮想環境のIPアドレス
                server: '0.0.0.0',       // Dockerのコンテナ上で動かすのでワイルドカードIPアドレスを指定
              },
              // hot-reloadで使われるポートを固定
              port:{
                server:3002,
                client: 3002
                },
              allEntries: true
            },
        },
      watch:true,
      watchOptions: {
        ignored: /node_modules/,
        aggregateTimeout: 300,
        poll: 5000
      },
    });
}

if (MODE === "production") {
    console.log("Building for Production...");
    module.exports = merge(common, {
        plugins: [
            // Delete everything from output directory and report to user
            new CleanWebpackPlugin(["dist"], {
                root: __dirname,
                exclude: [],
                verbose: true,
                dry: false
            }),
            new CopyWebpackPlugin([
                {
                    from: "src/assets"
                }
            ]),
            new MiniCssExtractPlugin({
                filename: "[name]-[hash].css"
            })
        ],
        module: {
            rules: [
                {
                    test: /\.elm$/,
                    exclude: [/elm-stuff/, /node_modules/],
                    use: [
                        { loader: "elm-webpack-loader", options:{optimize: true} }
                    ]
                },
            {
                test: /\.css$/,
                exclude: [/elm-stuff/, /node_modules/],
                loaders: [MiniCssExtractPlugin.loader, "css-loader"]
            },
            {
                test: /\.sass$/,
                exclude: [/elm-stuff/, /node_modules/],
                loaders: [MiniCssExtractPlugin.loader, "css-loader",postCssLoader, "sass-loader"]
            }
            ]
        }
    });
}
