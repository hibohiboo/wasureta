#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)

cd $bin_dir/../docker && docker-compose run firebase /bin/bash -c "cd /app/functions && npm run -s lint " $@
