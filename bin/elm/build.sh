#!/bin/bash

# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)
name=${1:-elm}
dir_docker="$bin_dir/../../docker"
inputFile="/app/src/assets/js/elm/characters/views/Main.elm"
outputFile="/app/dist/js/elm/characters/views/Main.js"
minFile="/app/dist/js/elm/characters/views/Main.js"

# docker-composeの起動。 
cd $dir_docker  && docker-compose run $name /bin/bash -c "yarn run elm make $inputFile --output=$outputFile --optimize && uglifyjs $outputFile --compress 'pure_funcs=\"F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9\",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=$minFile"
