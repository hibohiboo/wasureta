#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)
composeFile=${1:-"docker-compose.yml"}

cd $bin_dir/../docker && docker-compose -f $composeFile run -e NODE_ENV=production webpack npm run webpack