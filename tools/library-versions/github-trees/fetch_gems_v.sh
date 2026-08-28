#!/bin/bash
# Fetch recursive lib/ tree for gem@version pairs, filename includes version.
set -u
SP=/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad
GH="$SP/file-check/github"
LIST="$1"
LOG="$2"
: > "$LOG"

while IFS=$'\t' read -r gemname version repo rev; do
  [ -z "$gemname" ] && continue
  outfile="$GH/gem-${gemname}-${version}-files.txt"
  if [ -f "$outfile" ]; then
    echo "$gemname@$version: already fetched, skip" >> "$LOG"
    continue
  fi
  ref_used=""
  sha=""
  if [ -n "$rev" ]; then
    s=$(gh api "repos/$repo/commits/$rev" --jq .commit.tree.sha 2>/dev/null)
    if [[ "$s" =~ ^[0-9a-f]{40}$ ]]; then sha="$s"; ref_used="$rev(explicit-rev)"; fi
  fi
  if [ -z "$sha" ]; then
    for candidate in "v$version" "$version"; do
      s=$(gh api "repos/$repo/commits/$candidate" --jq .commit.tree.sha 2>/dev/null)
      if [[ "$s" =~ ^[0-9a-f]{40}$ ]]; then sha="$s"; ref_used="$candidate"; break; fi
    done
  fi
  if [ -z "$sha" ]; then
    defbranch=$(gh api "repos/$repo" --jq .default_branch 2>/dev/null)
    s=$(gh api "repos/$repo/commits/$defbranch" --jq .commit.tree.sha 2>/dev/null)
    if [[ "$s" =~ ^[0-9a-f]{40}$ ]]; then sha="$s"; ref_used="$defbranch(default-branch-fallback)"; fi
  fi
  if [ -z "$sha" ]; then
    echo "$gemname@$version: FAILED to resolve any ref (repo=$repo)" >> "$LOG"
    continue
  fi
  libsha=$(gh api "repos/$repo/git/trees/$sha" --jq '.tree[] | select(.path=="lib") | .sha' 2>/dev/null)
  if [ -z "$libsha" ]; then
    echo "$gemname@$version: ref=$ref_used sha=$sha -- NO 'lib' dir at root!" >> "$LOG"
    : > "$outfile"
    continue
  fi
  trunc=$(gh api "repos/$repo/git/trees/$libsha?recursive=1" --jq '.truncated' 2>/dev/null)
  gh api "repos/$repo/git/trees/$libsha?recursive=1" --jq '.tree[] | select(.type=="blob") | .path' > "$outfile" 2>/dev/null
  echo "$gemname@$version: repo=$repo ref=$ref_used lib-tree-sha=$libsha truncated=$trunc lines=$(wc -l < "$outfile") -> $outfile" >> "$LOG"
done < "$LIST"
