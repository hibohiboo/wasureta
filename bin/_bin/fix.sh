#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)

bash $bin_dir/scss/fix.sh
bash $bin_dir/ts/fix.sh
bash $bin_dir/js/fix.sh
