
module.exports = {
  configureWebpack: {
    externals: {
      jquery: 'jQuery'
      , firebase: 'firebase'
      , moment: 'moment'
    },
  },
  devServer: {
    // sock.js用に仮想環境のIPとポートを指定
    public: "192.168.50.10:8080",
    historyApiFallback: {
      rewrites: [
        {
          from: new RegExp(`/${process.env.VUE_APP_BASE_URL}/chatLog.html`),
          to: "chatLog.html"
        },
        {
          from: new RegExp(`/${process.env.VUE_APP_BASE_URL}/`),
          to: "index.html"
        } // index.html に飛ばす
      ]
    },
    watchOptions: {
      poll: true
    },
    disableHostCheck: true,
    hotOnly: true,
    clientLogLevel: "warning",
    inline: true,
  }
};
