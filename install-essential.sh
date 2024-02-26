#!/bin/bash

apt-add-repository -y ppa:fish-shell/release-3
apt-add-repository -y ppa:ansible/ansible

apt-get update -y
apt-get upgrade -y

apt-get install -y software-properties-common micro git curl wget \
  tldr make fish build-essential jq net-tools moreutils

# install yq
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
  -O /usr/bin/yq && chmod +x /usr/bin/yq

# set fish as default shell
chsh -s /usr/bin/fish "$USER"

# configure fish keybindings
mkdir -p "$HOME"/.config/fish
touch "$HOME"/.config/fish/config.fish
chown -R "$USER":"$USER" "$HOME"

keybindings="$HOME/.config/fish/functions/fish_user_key_bindings.fish"
tee "$keybindings" <<EOF
function fish_user_key_bindings
  fzf_key_bindings

  #bind \x7F 'backward-kill-bigword'
  bind \e\[3\;3~ delete-current-history-search

  # right = auto complete word
  bind \e\[C forward-word forward-single-char

  # ctrl + z = undo
  bind \\Cz undo
end
EOF

# enable docker service iif docker is installed
if command -v docker; then
  systemctl enable docker.service
  systemctl enable containerd.service

  # configure json-file logging
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

# install starship shell prompt
wget https://starship.rs/install.sh
chmod +x install.sh
./install.sh -y
rm install.sh
echo 'eval "$(starship init bash)"' >>"$HOME"/.bashrc
echo 'starship init fish | source' >>"$HOME"/.config/fish/config.fish

# install homebrew
su "$USER" ./install-essential-user.sh

# install node with nvs
export NVS_HOME="$HOME/.nvs"
echo 'export NVS_HOME="$HOME/.nvs"' >> "$HOME"/.bashrc
echo 'export NVS_HOME="$HOME/.nvs"' >> "$HOME"/.config/fish/config.fish
git clone https://github.com/jasongin/nvs "$NVS_HOME"
. "$NVS_HOME/nvs.sh" install
nvs add 18
nvs link 18
nvs use 18

# cleanup
apt-get autoremove -y
apt-get clean