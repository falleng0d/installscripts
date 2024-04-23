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

# set fish as default shell
if ! grep -Fxq "/usr/bin/fish" /etc/shells
then
  chsh -s /usr/bin/fish "$USER"
fi

# configure fish keybindings
mkdir -p "$HOME/.config/fish/functions"
touch "$HOME/.config/fish/config.fish"
chown -R "$USER":"$USER" "$HOME"

keybindings="$HOME/.config/fish/functions/fish_user_key_bindings.fish"
if [ ! -f "$keybindings" ]; then
  tee "$keybindings" <<EOF
function fish_user_key_bindings
  #bind \x7F 'backward-kill-bigword'
  bind \e\[3\;3~ delete-current-history-search

  # right = auto complete word
  bind \e\[C forward-word forward-single-char

  # ctrl + z = undo
  bind \\Cz undo
end
EOF
fi

# install starship shell prompt
if ! command -v starship &> /dev/null
then
  wget https://starship.rs/install.sh -O install-starship.sh
  chmod +x install-starship.sh
  ./install-starship.sh -y
  rm install-starship.sh
  addLine 'eval "$(starship init bash)"' "$HOME/.bashrc"
  addLine 'starship init fish | source' "$HOME/.config/fish/config.fish"
fi

# install homebrew
chown -R "$USER":"$USER" "$HOME"
su -P "$USER" -c "USER=$USER HOME=$HOME ./install-essential-user.sh"

# install node with nvs
if [ ! -d "$HOME/.nvs" ]; then
  export NVS_HOME="$HOME/.nvs"
  git clone https://github.com/jasongin/nvs "$NVS_HOME"
  . "$NVS_HOME/nvs.sh" install
  [ -s "$NVS_HOME/nvs.sh" ] && . "$NVS_HOME/nvs.sh"
  nvs add 18
  nvs link 18
  nvs use 18
fi

addLine 'export NVS_HOME="$HOME/.nvs"' "$HOME/.bashrc"
addLine '[ -s "$NVS_HOME/nvs.sh" ] && . "$NVS_HOME/nvs.sh"' "$HOME/.bashrc"
addLine 'export NVS_HOME="$HOME/.nvs"' "$HOME/.config/fish/config.fish"

# enable docker service iif docker is installed
if command -v docker; then
  systemctl enable docker.service
  systemctl enable containerd.service

  # configure json-file logging
  if ! grep -q '"max-size": "10m"' '/etc/docker/daemon.json' 2>/dev/null; then
    mkdir -p /etc/docker
    tee /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
  fi
fi

chown -R "$USER":"$USER" "$HOME"
