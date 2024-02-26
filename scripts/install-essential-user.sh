#!/bin/bash

set -e

echo "Installing essential packages"

# install homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "$HOME"/.bashrc
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "$HOME"/.config/fish/config.fish

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# install python 3.12
brew install python@3.12
ln -sf /home/linuxbrew/.linuxbrew/bin/python3.12 /home/linuxbrew/.linuxbrew/bin/python3
ln -sf /home/linuxbrew/.linuxbrew/bin/pip3.12 /home/linuxbrew/.linuxbrew/bin/pip3

python3 -m pip install --upgrade pip --break-system-packages
python3 -m pip install --upgrade setuptools --break-system-packages

# install python packages
brew install ansible poetry fzf
