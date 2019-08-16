#!/bin/bash
bin_dir=$(cd $(dirname $0) && pwd)
build_dir=$(cd $bin_dir/separate && pwd)

msg=`$build_dir/html.sh`
if [ $? -gt 0 ]; then
    echo "html error. please modify" 
    exit 1
fi

msg=`$build_dir/css.sh`
if [ $? -gt 0 ]; then
    echo "css error. please modify" 
    exit 1
fi

parent_dir=$(cd $bin_dir/.. && pwd)
target_dir=$(cd $parent_dir/../app/public/ && pwd)

\cp -rf $parent_dir/dist/public/* $target_dir
echo "html, css 出力完了"
exit 0
