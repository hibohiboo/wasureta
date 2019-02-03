#!/bin/bash

bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$bin_dir/../../..
docker_dir=$parent_dir/docker
dir_docker=$docker_dir
name=${1:-elm}

cd $dir_docker  && docker-compose run  $name yarn webpack --config webpack.config.separate.js

# Webpack html pluginではassetsの相対参照はできない。 https://code.i-harness.com/ja/q/21044d4
# なので、いったん出力した後、assetsの相対パスを参照するようにパスを修正。
# null文字を区切りとして使うように、find -print0 と xargs -0のオプションを指定
# https://qiita.com/somat/items/b775f7e082f1559707e2
cd $dir_docker  && docker-compose run  $name bash -c 'find /app/separate/dist/**/*.html -print0 | xargs -0 sed -i -e "s/assets/..\\/assets/g"'