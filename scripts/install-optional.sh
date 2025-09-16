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

# Function to prompt user with Y/n (defaults to yes)
prompt_user() {
    local message="$1"
    echo -n "$message [Y/n]: "
    read -r response
    case "$response" in
        [nN]|[nN][oO])
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

# install starship shell prompt
if ! command -v starship &> /dev/null; then
    if prompt_user "Install Starship shell prompt?"; then
        echo "Installing Starship shell prompt..."
        wget https://starship.rs/install.sh -O install-starship.sh
        chmod +x install-starship.sh
        ./install-starship.sh -y
        rm install-starship.sh
        addLine 'eval "$(starship init bash)"' "$HOME/.bashrc"
        addLine 'starship init fish | source' "$HOME/.config/fish/config.fish"
        echo "Starship installation completed."
    else
        echo "Skipping Starship installation."
    fi
fi

# enable docker service iif docker is installed
if command -v docker; then
    if prompt_user "Enable Docker services and configure logging?"; then
        echo "Enabling Docker services..."
        systemctl enable docker.service
        systemctl enable containerd.service

        # configure json-file logging
        if ! grep -q '"max-size": "10m"' '/etc/docker/daemon.json' 2>/dev/null; then
            echo "Configuring Docker logging..."
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
        echo "Docker configuration completed."
    else
        echo "Skipping Docker configuration."
    fi
fi

# set fish as default shell
if ! grep -Fxq "/usr/bin/fish" /etc/shells; then
    if prompt_user "Set Fish as the default shell?"; then
        echo "Setting Fish as default shell..."
        chsh -s /usr/bin/fish "$USER"
        echo "Default shell changed to Fish."
    else
        echo "Keeping current default shell."
    fi
fi

# configure fish keybindings
if prompt_user "Configure Fish shell keybindings?"; then
    echo "Configuring Fish keybindings..."
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
        echo "Fish keybindings configured."
    else
        echo "Fish keybindings file already exists, skipping."
    fi
else
    echo "Skipping Fish keybindings configuration."
fi
