#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)

cp -r $bin_dir/../app/public $bin_dir/../bkup/public-` date +"%Y%m%d%I%M%S"`

# html作成
bash $bin_dir/pug/build.sh

# 静的ファイルコピー
# bash $bin_dir/files/build.sh

# scss -> postcss の順番で依存関係があるので、順番を入れ替えてはならない
bash $bin_dir/scss/build.sh
bash $bin_dir/postcss/build.sh

# 廃棄世界漂流をビルド
# bash $bin_dir/../go-waste/bin/build.sh

# インセインのハンドアウトメーカーをビルド
# bash $bin_dir/../insane/bin/build.sh

# pugで作成したhtmlをコピー
cp -r $bin_dir/../dist/html/index.html $bin_dir/../app/public/index.html
cp -r $bin_dir/../dist/html/privacy-policy.html $bin_dir/../app/public/privacy-policy.html
cp -r $bin_dir/../dist/assets $bin_dir/../app/public/assets


# 以下、 bkup
# rm -rf $bin_dir/../app/public
# rm -rf $bin_dir/../dist/assets
# rm -rf $bin_dir/../dist/html
# rm -rf $bin_dir/../pre-dist/assets

# # elm -> ts -> js の順番で、依存関係
# bash $bin_dir/elm/build.sh
# bash $bin_dir/ts/build.sh
# bash $bin_dir/js/build.sh

# bash $bin_dir/webpack/build.sh


# container_name=${1:-webpack}

# # $container_nameの有無をgrepで調べる
# docker ps | grep $container_name

# # grepの戻り値$?の評価。 grep戻り値 0:一致した 1:一致しなかった
# if [ $? -eq 0 ]; then
#   # 一致したときの処理
#   cd $bin_dir/../docker && docker-compose exec -e NODE_ENV=production $container_name yarn prod
# else
#   # 一致しなかった時の処理
#   # コンテナを立ち上げて接続
#   cd $bin_dir/../docker && docker-compose run -e NODE_ENV=production $container_name /bin/bash -c 'cp -r /app/dist /bkup/public-` date +"%Y%m%d%I%M%S"` && rm -rf /app/dist/* && yarn prod'
# fi
