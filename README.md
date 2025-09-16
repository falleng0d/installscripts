# Install Scripts

A comprehensive collection of automated installation scripts for setting up a modern development environment on Ubuntu/Linux systems. This project provides both local installation scripts and a Docker-based containerized environment for consistent, reproducible development setups.

## 🚀 Features

- **Automated Setup**: One-command installation of essential development tools
- **Docker Support**: Containerized environment for consistent setups across different systems
- **Modern Shell**: Fish shell with custom keybindings and Starship prompt
- **Development Tools**: Node.js (via NVS), Python 3.12, Homebrew, and essential utilities

## 📋 What Gets Installed

### Base Packages

- **Shell & Terminal**: Fish shell, Starship prompt
- **Development Tools**: Git, Make, Build essentials, Micro editor
- **Utilities**: curl, wget, jq, yq, tldr, net-tools, moreutils
- **Package Managers**: Homebrew (Linuxbrew)

### Programming Languages & Tools

- **Node.js**: Version 18 (managed via NVS - Node Version Switcher)
- **Python**: Version 3.12 with pip
- **Development Tools**: Ansible, Poetry, fzf

### Shell Configuration

- Fish shell as default with custom keybindings:
  - Right arrow: Auto-complete word
  - Ctrl+Z: Undo
  - Alt+Delete: Delete current history search
- Starship prompt for both Bash and Fish
- Persistent shell history

## 🛠️ Prerequisites

### For Local Installation

- Ubuntu/Debian-based Linux distribution
- `sudo` privileges
- Internet connection

### For Docker Installation

- Docker installed and running
- Make (optional, for using Makefile commands)

## 📦 Installation Methods

### Method 1: Local Installation

Clone the repository and run the installation script:

```bash
git clone https://github.com/falleng0d/installscripts.git && cd installscripts && make install
```

Or manually:

```bash
chmod +x ./scripts/*.sh
cd scripts && ./install.sh
```

### Method 2: Docker Environment

#### Using Make (Recommended)

```bash
# Build the Docker image
make build

# Run the container (Linux/macOS)
make run

# Run the container (Windows PowerShell)
make run-powershell
```

#### Manual Docker Commands

```bash
# Build the image
docker build --tag install-essential .

# Run the container
docker run --rm -it install-essential
```

## 🐳 Docker Environment Details

The Docker environment:
- Based on Ubuntu latest
- Creates an `ubuntu` user with sudo privileges
- Mounts local directories for persistent shell history
- Uses Fish shell as the entry point
- Preserves your scripts and configuration between runs

### Persistent Data

The Docker setup mounts the following for persistence:

- `./scripts` → `/home/ubuntu/scripts` (your scripts)
- `./home/.bash_history` → `/home/ubuntu/.bash_history` (bash history)
- `./home/fish_history` → `/home/ubuntu/.local/share/fish/fish_history` (fish history)

## 🔧 Script Breakdown

### `install.sh`
Main orchestrator script that runs both base and essential package installations.

### `install-packages.sh`
Installs system packages via apt:
- Adds Fish shell and Ansible PPAs
- Installs base development tools and utilities
- Downloads and installs yq (YAML processor)

### `install-essential.sh`
Configures the development environment:
- Sets Fish as default shell
- Configures Fish keybindings
- Installs Starship prompt
- Sets up Homebrew
- Installs Node.js via NVS
- Configures Docker logging (if Docker is installed)

### `install-essential-user.sh`
User-space installations via Homebrew:
- Installs Homebrew (Linuxbrew)
- Installs Python 3.12
- Installs development tools (Ansible, Poetry, fzf)

## 🎯 Usage

After installation, you'll have:

1. **Fish Shell**: Modern shell with syntax highlighting and autocompletion
2. **Starship Prompt**: Beautiful, informative command prompt
3. **Node.js 18**: Ready for JavaScript/TypeScript development
4. **Python 3.12**: Latest Python with Poetry for dependency management
5. **Development Tools**: All essential tools for modern development

### Quick Start Commands

```bash
# Check installed versions
node --version
python3 --version
fish --version

# Use Poetry for Python projects
poetry new my-project

# Use NVS for Node.js version management
nvs list
nvs use 18
```

## 🔍 Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure you have sudo privileges
2. **Network Issues**: Check internet connection for downloads
3. **Docker Issues**: Ensure Docker is running and you have permissions

### Logs

Docker build logs are saved to `build.log` for debugging.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with both local and Docker installations
5. Submit a pull request

## 🔗 Related Tools

- [Fish Shell](https://fishshell.com/) - User-friendly command line shell
- [Starship](https://starship.rs/) - Cross-shell prompt
- [Homebrew](https://brew.sh/) - Package manager for macOS and Linux
- [NVS](https://github.com/jasongin/nvs) - Node Version Switcher
- [Poetry](https://python-poetry.org/) - Python dependency management
