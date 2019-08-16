#!/bin/bash
bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$(cd $bin_dir/.. && pwd)
docker_dir=$(cd $parent_dir/docker && pwd)
container_name=firebase
# docker-composeの起動。 OAuth用に9005. サンプルアプリ用に5000ポートを開放。
cd  $docker_dir && docker-compose run -p 9005:9005 -p 5000:5000 $container_name firebase deploy --token "$FIREBASE_TOKEN" --project wasureta-d6b34 --only firestore:rules
