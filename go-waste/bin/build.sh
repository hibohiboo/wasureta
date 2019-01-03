#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)

rm -rf $bin_dir/../app/public/insane
rm -rf $bin_dir/../dist/assets
rm -rf $bin_dir/../dist/html
rm -rf $bin_dir/../pre-dist/assets

# html作成
bash $bin_dir/pug/build.sh
