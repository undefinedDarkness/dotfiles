#!/usr/bin/env bash

rs_file=$1
dir=$(dirname "$rs_file")

# Only loop twice
for _ in 1 2 3
do
  if [ -f "$dir/Cargo.toml" ]
  then
    echo "TRUE"
    exit
  else
    dir=$(dirname "$dir")
  fi
done
