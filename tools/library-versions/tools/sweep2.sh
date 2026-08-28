#!/bin/sh
# $1=ruby, $2=names file, $3=out tsv, $4=req_classify.rb path
: > "$3"
V=$(mktemp)
while read -r n; do
  : > "$V"
  OUT="$V" timeout 20 "$1" "$4" "$n" >/dev/null 2>&1 || true
  r=$(cat "$V"); [ -n "$r" ] || r=timeout
  printf '%s\t%s\n' "$n" "$r" >> "$3"
done < "$2"
rm -f "$V"
