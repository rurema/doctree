#!/bin/sh
# usage: measure2.sh <ver> <ruby>  — 単体 require に失敗したサブライブラリを親ライブラリ pre-require 付きで再測定
V=$1; R=$2; IN=/work/probe-in/$V; OUT=/work/real/$V; T=/work/tools/dump_all_pre.rb
TO=""; command -v timeout >/dev/null 2>&1 && TO="timeout 120"
: > "$OUT/status2.tsv"
for f in "$OUT"/libs/*.tsv; do
  grep -q '^X' "$f" || continue
  id=$(basename "$f" .tsv); lib=$(cat "$IN/$id.name")
  case "$lib" in */*) pre=${lib%%/*} ;; *) continue ;; esac
  $TO $R "$T" --pre "$pre" --lib "$lib" --probe "$IN/$id.in" > "$OUT/libs/$id.tsv.new" 2> "$OUT/libs/$id.err"
  if grep -q '^X' "$OUT/libs/$id.tsv.new"; then rm "$OUT/libs/$id.tsv.new"; echo "$id	$lib	$pre	still-failed" >> "$OUT/status2.tsv"
  else mv "$OUT/libs/$id.tsv.new" "$OUT/libs/$id.tsv"; echo "$id	$lib	$pre	ok" >> "$OUT/status2.tsv"; fi
done
echo done > "$OUT/DONE2"
