#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$bin_dir/../../..
docker_dir=$parent_dir/docker
dir_docker=$docker_dir
name=${1:-elm}
# docker-composeの起動。 
cd $dir_docker && docker-compose run $name yarn pug /app/src -o /app/separate/pre-dist
