#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)

bash $bin_dir/scss/fix.sh
