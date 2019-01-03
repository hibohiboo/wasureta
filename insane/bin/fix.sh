#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$bin_dir/..
docker_dir=$parent_dir/docker
container_name=${1:-elm}

# up.sh docker-compose.camp.yml
composeFile=${1:-"docker-compose.yml"}

# js-fix
cd $docker_dir && docker-compose -f $composeFile run $container_name  yarn run -s eslint --fix --ext .js  src 
