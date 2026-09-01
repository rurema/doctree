#!/bin/sh
# $1=ruby binary, $2=split dir, $3=probe.rb path, $4=output tsv
: > "$4"
for f in "$2"/*.in; do
  base=${f%.in}
  lib=$(cat "$base.name")
  timeout 90 "$1" "$3" "$lib" < "$f" | awk -v L="$lib" -F'\t' '{OFS="\t"; print L, $0}' >> "$4"
done
