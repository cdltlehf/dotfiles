#!/usr/bin/env bash
# Deprecated. I don't use it

# TODO: dump
# TODO: doc
install() {
  local repo
  local author
  local plugin

  local bundle
  local name


  if [[ $1 =~ https://github.com/(.*)/(.*).git ]]; then
    author="${BASH_REMATCH[1]}"
    plugin="${BASH_REMATCH[2]}"

  elif [[ $1 =~ (.*)/(.*) ]]; then
    author="${BASH_REMATCH[1]}"
    plugin="${BASH_REMATCH[2]}"

  else
    echo 'Error: Invalid repo'
    return 1

  fi
  repo="https://github.com/$author/$plugin.git"

  if [[ -n $2 ]]; then
    if [[ $2 =~ (.*)/(.*) ]]; then
      bundle="${BASH_REMATCH[1]}"
      name="${BASH_REMATCH[2]}"
    else
      echo 'Error: Invalid target'
      return 1
    fi
  else
    bundle=$author
    name=$plugin
  fi

  if ! [[ -e "./.vim/pack/$bundle/opt/$name" ]]; then
    git submodule add "$repo" "./.vim/pack/$bundle/opt/$name"
  fi
}

install 'dracula/vim' 'themes/dracula'
install 'airblade/vim-gitgutter'
