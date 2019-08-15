    
#!/bin/bash

this_dir=$(cd $(dirname $0) && pwd)
bin_dir=$(cd $this_dir/../  && pwd)
parent_dir=$(cd $bin_dir/.. && pwd)
docker_dir=$(cd $parent_dir/docker && pwd)
name=${1:-pug}

cd $docker_dir  && docker-compose run $name npm run build-pug

# 拡張子指定に半角空白を入れないように注意。 【{png,jpg}:OK】【{png, jpg}:NG】
cd $docker_dir && docker-compose run  $name yarn run cpx "/app/src/**/*.{png,jpg}" /app/public 