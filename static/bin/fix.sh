    
#!/bin/bash

bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$(cd $bin_dir/.. && pwd)
docker_dir=$(cd $parent_dir/docker && pwd)
name=${1:-scss}

cd $docker_dir && docker-compose run  $name yarn run stylelint /app/src/assets/css/*.scss --fix
