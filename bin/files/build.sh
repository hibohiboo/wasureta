#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)
name=${1:-files}
dir_docker="$bin_dir/../../docker"
# 拡張子指定に半角空白を入れないように注意。 【{png,jpg}:OK】【{png, jpg}:NG】
cd $dir_docker && docker-compose run  $name yarn run cpx "/app/src/**/*.{png,jpg}" /app/dist 
cd $dir_docker && docker-compose run  $name yarn run cpx "/app/src/**/*.{png,jpg}" /app/pre-dist 
cd $dir_docker && docker-compose run  $name yarn run cpx "/app/src/**/*.{png,jpg}" /app/public 
