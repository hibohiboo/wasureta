#!/bin/bash

msg=`static/bin/build.sh`
if [ $? -gt 0 ]; then
    echo "static html css error. please modify" 
    exit 1
fi

echo "HTML,CSS ビルド完了"
exit 0
