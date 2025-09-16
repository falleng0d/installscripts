#!/bin/bash

apt-add-repository -y ppa:fish-shell/release-3
apt-add-repository -y ppa:ansible/ansible

apt-get update -y

apt-get install -y software-properties-common micro git curl wget tldr make fish jq net-tools

# install yq
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
  -O /usr/bin/yq && chmod +x /usr/bin/yq
