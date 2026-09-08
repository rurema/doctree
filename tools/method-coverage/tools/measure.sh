#!/bin/sh
# usage: measure.sh <ver> <ruby>   (コンテナ内。/work = このディレクトリ tools/method-coverage をマウントしたもの)
V=$1; R=$2; IN=/work/probe-in/$V; OUT=/work/real/$V; T=/work/tools/dump_all.rb
mkdir -p "$OUT/libs"
TO=""; command -v timeout >/dev/null 2>&1 && TO="timeout 120"
$R -v > "$OUT/ruby-v.txt" 2>&1
# 組み込み(gems 無効)= 基準。_builtin エントリのプローブも同時に
BI=$(grep -P '\t_builtin\t' "$IN/manifest.tsv" | cut -f1)
$R --disable-gems "$T" --probe "$IN/$BI.in" > "$OUT/builtin.tsv" 2> "$OUT/builtin.err"
# gems 有効の素の状態(rubygems・did_you_mean 等の事前ロード分)
$R "$T" > "$OUT/base.tsv" 2> "$OUT/base.err"
: > "$OUT/status.tsv"
for f in "$IN"/*.in; do
  b=${f%.in}; id=$(basename "$b"); lib=$(cat "$b.name")
  [ "$lib" = "_builtin" ] && continue
  $TO $R "$T" --lib "$lib" --probe "$f" > "$OUT/libs/$id.tsv" 2> "$OUT/libs/$id.err"
  echo "$id	$lib	$?" >> "$OUT/status.tsv"
done
echo done > "$OUT/DONE"
