const path = require("path");
const globule = require('globule');
const merge = require("webpack-merge");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const CleanWebpackPlugin = require("clean-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HTMLWebpackPlugin = require("html-webpack-plugin");

const MODE = process.env.NODE_ENV === "production" ? "production" : "development";
let filename = "[name].js";
if (MODE == "production" ) {
  // filename = "[name]-[hash].js";
}

// ソース・出力先の設定
const opts = {
  src: path.join(__dirname, 'src'),
  dest: path.join(__dirname, 'dist')
}
const files = {};
globule
.find([`assets/**/*.js`, `!assets/**/_*.js`,  `!assets/**/elm`], {cwd: opts.src})
.forEach(filename => {
  const key = filename.replace(new RegExp(`.js$`, 'i'), ``)
  const value = path.join(opts.src, filename)
  files[key] = value
});

const htmlWebpackPlugins = [
  {
    name: "index",
    chunks:[]
  },
  {
    name: "about",
    chunks:[]
  },
  {
    name: "agreement",
    chunks:[]
  },
  {
    name: "privacy-policy",
    chunks:[]
  },
  {
    name: "rulebook",
    chunks:[]
  },
  {
    name: "rulebook",
    chunks:[]
  },
  {
    name: "sign-in",
    chunks:[]
  },
  {
    name: "characters/index",
    chunks:[]
  },
  {
    name: "characters/add",
    chunks:['js/characters/edit']
  },
  {
    name: "characters/view",
    chunks:['js/characters/view', ]
  },
  {
    name: "scenarios/sample1",
    chunks:[]
  }
].map(obj=>{
  obj.chunks.push('css/style');
  obj.chunks.push('js/navigation');
  
  const chunks = obj.chunks.map(s=>`assets/${s}`);
  
  return new HTMLWebpackPlugin({
    filename: `go-waste/${obj.name}.html`,
    template: `/app/src/html/go-waste/${obj.name}.html`,
    chunks: chunks
  })
})

let common = {
  mode: 'development',
  context: opts.src,
  entry: files,
  output: {
      path: opts.dest ,
      filename:  filename
  },
  resolve: {
      modules: [opts.src, "node_modules"],
      extensions: [".js"]
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: { loader: "babel-loader"}
      }
    ]
  },
  plugins: [...htmlWebpackPlugins ],
  // cdnから読み込むものはここに
  externals: {
    jquery: 'jQuery',
    firebase: 'firebase',
    firebaseui: 'firebaseui',
    vue: 'Vue',
    "chart.js": "Chart",
    Chart: false
  },
};

if (MODE === "production") {
  console.log("Building for Production...");

  // commonとマージ
  module.exports = merge(common, {
    optimization: {
      minimize: true,
    },
    plugins: [
      // Delete everything from output directory and report to user
      new CleanWebpackPlugin(["dist"], {
        root: __dirname,
        exclude: [],
        verbose: true,
        dry: false
      }),
      new CopyWebpackPlugin(
        [{ from: '', to: './', }, ],
        { context: 'html' }
      ),
      new MiniCssExtractPlugin({
        filename: '/assets/css/[name].css',
        chunkFilename: '/assets/css/[id].css'
      }),
    ],
    module: {
      rules: [
      {
        test: /\.css$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: MiniCssExtractPlugin.loader
          },
          {
            loader: 'css-loader',
            options: {
                url: false,
                minimize: true,
            }
          }
        ]
      }
      ]
    }
  });
}
