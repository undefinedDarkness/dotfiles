#!/usr/bin/env bash

source /etc/os-release

last_color=0
function prnt {
  local dot="•"
  local colors=("\u001b[31m" "\u001b[32m" "\u001b[33m" "\u001b[34m" "\u001b[35m" "\u001b[36m" "\u001b[37m")
  local reset="\u001b[0m"
  echo -e "${colors[$last_color]}$dot$reset $1"
  last_color=$((last_color + 1))
}

function distro_logo {
  local c0="\u001b[33;1m"
  local logo="
  ${c0}           _   
  ${c0}       ---(_) 
  ${c0}   _/  ---  \\
  ${c0}  (_) |   |   
  ${c0}    \\  --- _/
  ${c0}       ---(_) 
      "
  echo -e "$logo"
}

function color_panes {
f=3 b=4
for j in f b; do
    for i in {0..7}; do
        printf -v $j$i %b "\e[${!j}${i}m"
    done
done
d=$'\e[1m'
t=$'\e[0m'
v=$'\e[7m'
           
           
cat << EOF
           
$f1███$d▄$t  $f2███$d▄$t  $f3███$d▄$t  $f4███$d▄$t  $f5███$d▄$t  $f6███$d▄$t  $f7███$d▄$t  
$f1███$d█$t  $f2███$d█$t  $f3███$d█$t  $f4███$d█$t  $f5███$d█$t  $f6███$d█$t  $f7███$d█$t  
$f1███$d█$t  $f2███$d█$t  $f3███$d█$t  $f4███$d█$t  $f5███$d█$t  $f6███$d█$t  $f7███$d█$t  
$d$f1 ▀▀▀   $f2▀▀▀   $f3▀▀▀   $f4▀▀▀   $f5▀▀▀   $f6▀▀▀   $f7▀▀▀  
EOF
}

  function get_rust_v {
    local rustc_v
    rustc_v=$(rustc --version)
    read -r -a split_string <<< "$rustc_v"
    echo "${split_string[1]}"
  }

function count_pkgs {
  apt-mark showmanual | wc -l
}

clear
distro_logo
prnt "krnl $(uname -r)"
prnt "os $PRETTY_NAME"
#get_rust_v
prnt "rust $(get_rust_v)"
prnt "edtr $EDITOR"
prnt "shel bash"
prnt "pkgs $(count_pkgs)"

echo "" 
if [[ $1 != "--no-panes" ]]
then
  color_panes
fi
