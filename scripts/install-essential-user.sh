#!/bin/bash

set -eE -o functrace

clean_up() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
  exit 1
}
trap 'clean_up $LINENO "$BASH_COMMAND"' ERR

addLine() {
  if ! grep -q "$1" "$2" 2>/dev/null; then
    (echo; echo "$1") >> "$2"
  fi
}

echo "Installing essential packages"

# install homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

addLine 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' "$HOME/.bashrc"
addLine 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' "$HOME/.config/fish/config.fish"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# install python 3.12
brew install python@3.12
ln -sf /home/linuxbrew/.linuxbrew/bin/python3.12 /home/linuxbrew/.linuxbrew/bin/python3
ln -sf /home/linuxbrew/.linuxbrew/bin/pip3.12 /home/linuxbrew/.linuxbrew/bin/pip3

python3 -m pip install --upgrade pip --break-system-packages
python3 -m pip install --upgrade setuptools --break-system-packages

# install python packages
brew install ansible poetry fzf
