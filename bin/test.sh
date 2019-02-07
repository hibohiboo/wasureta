# このシェルスクリプトのディレクトリの絶対パスを取得。
bin_dir=$(cd $(dirname $0) && pwd)
workdir=$bin_dir/../insane

cd $workdir && elm-test