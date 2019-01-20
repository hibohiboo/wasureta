#!/bin/bash

bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$bin_dir/../../..
docker_dir=$parent_dir/docker
dir_docker=$docker_dir
name=${1:-elm}
inputFile="/app/src/assets/js/elm/characters/views/Main.elm"
outputFile="/app/separate/pre-pre-dist/assets/js/elm/characters/views/Main.js"
minFile="/app/separate/pre-pre-dist/assets/js/elm/characters/views/Main.js"

# docker-composeの起動。 
cd $dir_docker  && docker-compose run $name /bin/bash -c "yarn run elm make $inputFile --output=$outputFile --optimize && uglifyjs $outputFile --compress 'pure_funcs=\"F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9\",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=$minFile"

inputFile="/app/src/assets/js/elm/navigation/Main.elm"
outputFile="/app/separate/pre-pre-dist/assets/js/elm/navigation/Main.js"
minFile="/app/separate/pre-pre-dist/assets/js/elm/navigation/Main.js"

# docker-composeの起動。 
cd $dir_docker  && docker-compose run $name /bin/bash -c "yarn run elm make $inputFile --output=$outputFile --optimize && uglifyjs $outputFile --compress 'pure_funcs=\"F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9\",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=$minFile"
