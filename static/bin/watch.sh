    
#!/bin/bash

bin_dir=$(cd $(dirname $0) && pwd)
parent_dir=$(cd $bin_dir/.. && pwd)
docker_dir=$(cd $parent_dir/docker && pwd)
composeFile=${1:-"docker-compose.yml"}
cd $docker_dir &&  docker-compose -f $composeFile up -d
