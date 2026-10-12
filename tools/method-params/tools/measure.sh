#!/bin/sh
# measure.sh: docker で実 Ruby の parameters ダンプと同梱 rbs gem の core/stdlib の取り出しを行う。
# usage: measure.sh <method-params tool dir> <scratch dir>
#   <tool dir>   : tools/method-params(コンテナ内の /work にマウント。real/<版>/ に出力)
#   <scratch dir>: rbs のソースの置き場(コンテナ内の /scratch。<scratch>/rbs-src/<版>/{core,stdlib,VERSION})
# docker は 1 版ずつ順に起動する(並列だと OOM kill される)。
set -u
TOOL=${1:?usage: measure.sh <tool dir> <scratch dir>}
SCRATCH=${2:?usage: measure.sh <tool dir> <scratch dir>}
mkdir -p "$SCRATCH/rbs-src"
UIDGID="$(id -u):$(id -g)"

# コンテナ内で実行するスクリプト: $1=DB の版 $2=ruby のパス
INNER='
V=$1; R=$2; OUT=/work/real/$V; SRC=/scratch/rbs-src/$V
mkdir -p "$OUT" "$SRC"
$R -v > "$OUT/ruby-v.txt" 2>&1
$R --disable-gems /work/tools/dump_params.rb > "$OUT/builtin.tsv" 2> "$OUT/builtin.err"
GEM=$($R -e "puts Gem::Specification.find_by_name(%q(rbs)).gem_dir")
rm -rf "$SRC/core" "$SRC/stdlib"
cp -r "$GEM/core" "$SRC/core"
cp -r "$GEM/stdlib" "$SRC/stdlib"
$R -e "puts Gem::Specification.find_by_name(%q(rbs)).version" > "$SRC/VERSION"
'

run() { # run <DB の版> <image> <ruby>
  echo "== $1 ($2 $3) $(date +%T)"
  docker run --rm --user "$UIDGID" -e HOME=/tmp \
    -v "$TOOL:/work" -v "$SCRATCH:/scratch" \
    "$2" sh -c "$INNER" sh "$1" "$3"
  echo "   exit=$? lines=$(wc -l < "$TOOL/real/$1/builtin.tsv")"
}

for v in 3.0.0 3.1.0 3.2.0 3.3.0 3.4.0 4.0.0; do
  run "${v%.0}" ghcr.io/ruby/all-ruby "/all-ruby/build/$v/bin/ruby"
done
run 4.1 ghcr.io/ruby/ruby:master ruby
echo "== done"
