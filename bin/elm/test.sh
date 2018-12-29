#!/bin/bash

# ※ 動作未確認

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)

# docker-composeの起動。 コンテナ内に入る. 
cd $bin_dir/../../docker && docker-compose run elm npm run -s elm-test