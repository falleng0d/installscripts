#!/bin/bash

set -eE -o functrace

clean_up() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
  exit 1
}
trap 'clean_up $LINENO "$BASH_COMMAND"' ERR

# install homebrew
chown -R "$USER":"$USER" "$HOME"
mkdir -p /home/linuxbrew/.linuxbrew
chmod -R 777 /home/linuxbrew
su -P "$USER" -c "USER=$USER HOME=$HOME ./install-homebrew.sh"
chown -R "$USER":"$USER" "$HOME"
