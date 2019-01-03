#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$bin_dir/..
# rm -rf $bin_dir/../app/public/insane
# rm -rf $bin_dir/../dist/assets
# rm -rf $bin_dir/../dist/html
# rm -rf $bin_dir/../pre-dist/assets

# fix と postcssは速度が遅いので、別で実行するようにする
# lint-fix
# bash $bin_dir/scss/fix.sh 

# html作成
bash $bin_dir/pug/build.sh

# css作成
bash $bin_dir/scss/build.sh
# bash $bin_dir/postcss/build.sh

cp -rf $parent_dir/pre-dist/assets $parent_dir/dist/html/assets 