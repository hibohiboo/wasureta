    
#!/bin/bash

this_dir=$(cd $(dirname $0) && pwd)
bin_dir=$(cd $this_dir/../  && pwd)
parent_dir=$(cd $bin_dir/.. && pwd)
docker_dir=$(cd $parent_dir/docker && pwd)
name=${1:-scss}

msg=`$bin_dir/lint.sh`
if [ $? -gt 0 ]; then
    echo "lint error" 
    echo "prease modify css" 
    exit 1
fi


cd $docker_dir  && docker-compose run $name yarn run node-sass -r /app/src/assets/css -o /app/dist/assets/css

name=${1:-postcss}
cd $docker_dir  && docker-compose run $name yarn run postcss /app/src/assets/css/*.css --no-map --dir /app/dist/assets/css/