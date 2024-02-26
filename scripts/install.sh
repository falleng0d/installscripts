#!/bin/bash

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: ./install.sh <user> <home>"
    exit 1
fi

echo "Installing base packages"

./install-packages.sh

echo "Installing essential packages"

USER=$1 HOME=$2 ./install-essential.sh
