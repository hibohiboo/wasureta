#!/bin/bash

bin_dir=$(cd $(dirname $0) && pwd)
workdir=$(cd $bin_dir/../insane && pwd)

cd $workdir && elm-test