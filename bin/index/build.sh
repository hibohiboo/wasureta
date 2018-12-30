#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)
dir_root="$bin_dir/../.."
dir_docker="$dir_root/docker"

# docker-composeの起動。 
cd $dir_docker && docker-compose run pug yarn run pug /app/src/index.pug -o /app/dist/
cp -f $dir_root/dist/html/index.html $dir_root/app/public/index.html