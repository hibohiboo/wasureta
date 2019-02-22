# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)
root_dir=$bin_dir/../../
project_dir=$root_dir/../
udon_dir=$project_dir/udonarium
build_dir=$udon_dir/dest/dist/udonarium

cp -r $build_dir $root_dir/app/public/udonarium
