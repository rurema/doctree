#!/bin/sh
# measure_lib.sh: docker で標準添付ライブラリごとの parameters ダンプと同梱 rbs gem の core/stdlib の取り出しを行う。
# usage: measure_lib.sh <method-params tool dir> <scratch dir> [版...]
#   <tool dir>   : tools/method-params(コンテナ内の /work にマウント)。db-extract/sigs-<版>.tsv が必要
#   <scratch dir>: コンテナ内の /scratch。次を書く
#                  <scratch>/lib-raw/<版>/<符号化した名前>.tsv  ライブラリごとの dump_params.rb の出力(未加工)
#                  <scratch>/lib-err/<版>/<符号化した名前>.err  標準エラー出力(空なら作らない)
#                  <scratch>/rbs-src/<版>/{core,stdlib,VERSION} 同梱 rbs gem のソース
#   版           : 省略時は 3.0 3.1 3.2 3.3 3.4 4.0 4.1
#   符号化した名前: ライブラリ名の `/` を `__` にしたもの
# 出力: real/<版>/lib-status.tsv・real/<版>/lib-ruby-v.txt(未加工の出力は filter_lib.rb で real/<版>/lib.tsv に絞り込む)
# 対象: db-extract/sigs-<版>.tsv の lib 列のうち `_builtin` と SKIP 以外(シグネチャ行を持つライブラリ)と、
#       そのうちの `a/b` の形のものの親 `a`(compare_params.rb が親の行も引くため)。
# ライブラリごとに新しいプロセスで dump_params.rb --lib を実行する。require に失敗したら
# gems 有効で再実行し、それでも失敗したサブライブラリ(`a/b`)は親(`a`)を --pre で先に require して再実行する。
# lib-status.tsv: lib  mode(nogems|gems|pre:<親>|gems+pre:<親>|failed)  exit  P 行の数(未加工)
# docker は 1 版ずつ順に起動する(並列だと OOM kill される)。
set -u
TOOL=${1:?usage: measure_lib.sh <tool dir> <scratch dir> [ver...]}
SCRATCH=${2:?usage: measure_lib.sh <tool dir> <scratch dir> [ver...]}
shift 2
[ $# -eq 0 ] && set -- 3.0 3.1 3.2 3.3 3.4 4.0 4.1
mkdir -p "$SCRATCH/rbs-src" "$SCRATCH/lib-err" "$SCRATCH/lib-raw"
UIDGID="$(id -u):$(id -g)"

# コンテナ内で実行するスクリプト: $1=DB の版 $2=ruby のパス
INNER='
ulimit -c 0
V=$1; R=$2; OUT=/work/real/$V; RAW=/scratch/lib-raw/$V; ERR=/scratch/lib-err/$V; SRC=/scratch/rbs-src/$V; T=/work/tools/dump_params.rb
SKIP=" debug win32ole win32/registry win32/resolv "
TO="timeout 120"
rm -rf "$RAW" "$ERR"; mkdir -p "$OUT" "$RAW" "$ERR" "$SRC"
cd /tmp
$R -v > "$OUT/lib-ruby-v.txt" 2>&1
: > "$OUT/lib-status.tsv"
LIBS=$(tail -n +2 /work/db-extract/sigs-$V.tsv | cut -f1 | sort -u)
for lib in $( (echo "$LIBS"; echo "$LIBS" | grep / | grep -v "^win32/" | sed "s|/.*||") | sort -u); do
  [ "$lib" = _builtin ] && continue
  case "$SKIP" in *" $lib "*) continue ;; esac
  enc=$(echo "$lib" | sed "s|/|__|g"); f="$RAW/$enc.tsv"; e="$ERR/$enc.err"
  ok() { [ "$1" -eq 0 ] && ! grep -q "^X" "$f"; }
  mode=nogems; $TO $R --disable-gems $T --lib "$lib" > "$f" 2> "$e"; rc=$?
  if ! ok $rc; then mode=gems; $TO $R $T --lib "$lib" > "$f" 2>> "$e"; rc=$?; fi
  case "$lib" in */*) pre=${lib%%/*} ;; *) pre= ;; esac
  if ! ok $rc && [ -n "$pre" ]; then mode=pre:$pre; $TO $R --disable-gems $T --pre "$pre" --lib "$lib" > "$f" 2>> "$e"; rc=$?; fi
  if ! ok $rc && [ -n "$pre" ]; then mode=gems+pre:$pre; $TO $R $T --pre "$pre" --lib "$lib" > "$f" 2>> "$e"; rc=$?; fi
  ok $rc || mode=failed
  [ -s "$e" ] || rm -f "$e"
  printf "%s\t%s\t%s\t%s\n" "$lib" "$mode" "$rc" "$(grep -c "^P" "$f")" >> "$OUT/lib-status.tsv"
done
GEM=$($R -e "puts Gem::Specification.find_by_name(%q(rbs)).gem_dir")
rm -rf "$SRC/core" "$SRC/stdlib"
cp -r "$GEM/core" "$SRC/core"
cp -r "$GEM/stdlib" "$SRC/stdlib"
$R -e "puts Gem::Specification.find_by_name(%q(rbs)).version" > "$SRC/VERSION"
'

for v in "$@"; do
  case $v in
    4.1) img=ghcr.io/ruby/ruby:master; rb=ruby ;;
    *) img=ghcr.io/ruby/all-ruby; rb=/all-ruby/build/$v.0/bin/ruby ;;
  esac
  echo "== $v ($img $rb) $(date +%T)"
  docker run --rm --memory=1500m --user "$UIDGID" -e HOME=/tmp \
    -v "$TOOL:/work" -v "$SCRATCH:/scratch" \
    "$img" sh -c "$INNER" sh "$v" "$rb"
  echo "   exit=$? libs=$(wc -l < "$TOOL/real/$v/lib-status.tsv") failed=$(grep -c '	failed	' "$TOOL/real/$v/lib-status.tsv") $(date +%T)"
done
echo "== done"
