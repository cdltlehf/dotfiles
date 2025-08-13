#!/bin/bash

cd "$(dirname "$0")"

help() {
  echo "Usage: $0 <java|python|rust|node|pdflatex>"
}

if [ -z "$1" ]; then
  help
  exit 1
fi

case "$1" in
  java)
    ./installers/openjdk.sh
    ;;
  python)
    ./installers/miniforge3.sh
    ;;
  rust)
    ./installers/rustup.sh
    ;;
  node)
    ./installers/volta.sh
    ;;
  pdflatex)
    ./installers/texlive.sh
    ;;
  -h| --help)
    help
    ;;

esac
