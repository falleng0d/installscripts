#!/bin/bash

set -e

echo "Installing base packages"

sudo ./install-packages.sh

echo "Installing essential packages"

sudo USER="$(whoami)" HOME="$HOME" ./install-essential.sh
