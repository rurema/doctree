#!/bin/bash
# Fetch recursive lib/ tree for each bundled gem repo at pinned version tag.
# Usage: fetch_gems.sh <gemlist.tsv> <resolution-log-out>
set -u
SP=/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad
GH="$SP/file-check/github"
LIST="$1"
LOG="$2"
: > "$LOG"

while IFS=$'\t' read -r gemname version repo rev; do
  [ -z "$gemname" ] && continue
  outfile="$GH/gem-${gemname}-files.txt"
  if [ -f "$outfile" ]; then
    echo "$gemname: already fetched, skip" >> "$LOG"
    continue
  fi
  ref_used=""
  sha=""
  if [ -n "$rev" ]; then
    # explicit revision given
    sha=$(gh api "repos/$repo/commits/$rev" --jq .commit.tree.sha 2>/dev/null)
    if [ -n "$sha" ]; then
      ref_used="$rev(explicit-rev)"
    fi
  fi
  if [ -z "$sha" ]; then
    for candidate in "v$version" "$version"; do
      sha=$(gh api "repos/$repo/commits/$candidate" --jq .commit.tree.sha 2>/dev/null)
      if [ -n "$sha" ]; then
        ref_used="$candidate"
        break
      fi
    done
  fi
  if [ -z "$sha" ]; then
    # fallback to default branch
    defbranch=$(gh api "repos/$repo" --jq .default_branch 2>/dev/null)
    sha=$(gh api "repos/$repo/commits/$defbranch" --jq .commit.tree.sha 2>/dev/null)
    ref_used="$defbranch(default-branch-fallback)"
  fi
  if [ -z "$sha" ]; then
    echo "$gemname: FAILED to resolve any ref (repo=$repo version=$version)" >> "$LOG"
    continue
  fi
  # get root tree, find lib subtree sha
  libsha=$(gh api "repos/$repo/git/trees/$sha" --jq '.tree[] | select(.path=="lib") | .sha' 2>/dev/null)
  if [ -z "$libsha" ]; then
    echo "$gemname: ref=$ref_used sha=$sha -- NO 'lib' dir at root!" >> "$LOG"
    # save empty marker
    : > "$outfile"
    continue
  fi
  trunc=$(gh api "repos/$repo/git/trees/$libsha?recursive=1" --jq '.truncated' 2>/dev/null)
  gh api "repos/$repo/git/trees/$libsha?recursive=1" --jq '.tree[] | select(.type=="blob") | .path' > "$outfile" 2>/dev/null
  lines=$(wc -l < "$outfile")
  echo "$gemname: repo=$repo ref=$ref_used lib-tree-sha=$libsha truncated=$trunc lines=$lines -> $outfile" >> "$LOG"
done < "$LIST"
