#!/bin/bash

case "$(uname -s)" in
  *Darwin|Linux)
    command -v volta >/dev/null 2>&1 || install-volta
    volta install node
    ;;
  *)
    command -v nvm >/dev/null 2>&1 || install-nvm
    bash --login -c 'nvm install node'
    ;;
esac
