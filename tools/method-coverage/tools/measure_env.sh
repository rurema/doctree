#!/bin/bash
# usage: measure_env.sh <WORK> <ver>
# フル機能ビルド(ghcr.io/ruby/ruby:<ver>= --enable-yjit --enable-zjit)と all-ruby の同じ teeny(無ければ同 minor の最新)で
# 組み込み+標準添付を測定し、$WORK/env/<ver>/{full,allruby}/real/<ver>/ に出す。
# 事前に $WORK/probe-in/<ver>(gen_inputs.rb)と $WORK/tools(このディレクトリのコピー)を用意しておく。
set -u
W=$1; v=$2; E=$W/env
mkdir -p $E/$v
docker pull ghcr.io/ruby/ruby:$v > $E/$v/pull.log 2>&1 || { echo "pull failed $v"; exit 1; }
teeny=$(docker run --rm ghcr.io/ruby/ruby:$v ruby -e 'print RUBY_VERSION')
at=$(docker run --rm ghcr.io/ruby/all-ruby sh -c "ls /all-ruby/bin | grep -E '^ruby-$v\.[0-9]+\$' | sed 's/ruby-//' | sort -V | tail -1")
docker run --rm ghcr.io/ruby/all-ruby test -x /all-ruby/bin/ruby-$teeny && at=$teeny
echo "$v: full=$teeny allruby=$at"
for b in full allruby; do d=$E/$v/$b; rm -rf $d; mkdir -p $d/real; done
run() { d=$E/$v/$1
  docker run --rm --user $(id -u):$(id -g) -e HOME=/tmp -v $d:/work -v $W/probe-in:/work/probe-in -v $W/tools:/work/tools $2 sh /work/tools/measure.sh $v $3 > $d/measure.log 2>&1
  docker run --rm --user $(id -u):$(id -g) -e HOME=/tmp -v $d:/work -v $W/probe-in:/work/probe-in -v $W/tools:/work/tools $2 sh /work/tools/measure2.sh $v $3 > $d/measure2.log 2>&1
  echo "$1: $(cat $d/real/$v/ruby-v.txt) libs=$(ls $d/real/$v/libs/*.tsv | wc -l)"; }
run full ghcr.io/ruby/ruby:$v ruby
run allruby ghcr.io/ruby/all-ruby /all-ruby/bin/ruby-$at
docker rmi ghcr.io/ruby/ruby:$v > /dev/null 2>&1
echo "done $v"
