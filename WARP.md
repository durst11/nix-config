# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

This is a NixOS configuration repository that uses flakes to manage system configuration. The setup includes:
- COSMIC Desktop Environment (alpha version) 
- Modern terminal tooling (ghostty, warp-terminal from unstable)
- Development tools and utilities
- ZSH shell configuration
- Font management with nerd fonts
- Dotfile management via chezmoi

## Repository Structure

### Core Configuration Files
- `flake.nix` - Main flake configuration defining inputs and system outputs
- `configuration.nix` - Primary NixOS system configuration
- `hardware-configuration.nix` - Hardware-specific settings (ignored in git)
- `flake.lock` - Lock file pinning exact versions of dependencies

### Modular Configuration
- `cosmic.nix` - COSMIC desktop environment configuration
- `fonts.nix` - Font packages and configuration
- `zsh.nix` - ZSH shell setup with aliases and history
- `shell_scripts.txt` - Notes on useful CLI tools

### Development Files
- `nix-examples/` - Directory with configuration examples and backups
- `.gitignore` - Excludes hardware-configuration.nix and common development files

## System Architecture

### Flake Structure
The flake uses a hybrid approach with stable and unstable nixpkgs:
- `nixpkgs` (25.05 stable) - Primary package source
- `nixpkgs-unstable` - For cutting-edge packages like ghostty and warp-terminal
- System configuration for `jrd-t490` hostname

### Package Management Strategy
- System packages defined in `environment.systemPackages`
- Mix of stable and unstable packages using `unstablePkgs` pattern
- Rust-based tool replacements (uutils-coreutils, sudo-rs)
- Modern CLI tools: bat, eza, fd, ripgrep, fzf, zoxide, btop

### Desktop Environment
Uses COSMIC desktop (alpha) instead of GNOME/KDE, with:
- COSMIC greeter for login
- X11 windowing system
- Pipewire for audio

### Storage and Networking
- ZFS filesystem support
- Tailscale VPN integration
- Firewall configured for Tailscale

## Common Commands

### System Management
```bash
# Apply configuration changes
sudo nixos-rebuild switch

# Test configuration without switching
sudo nixos-rebuild test

# Build configuration without activating
sudo nixos-rebuild build

# Update flake inputs
nix flake update

# Check system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Flake Operations
```bash
# Show flake info
nix flake show

# Check flake syntax
nix flake check

# Update specific input
nix flake lock --update-input nixpkgs-unstable

# Show system configuration
nix show-config
```

### Development Tools Included
```bash
# Nix development tools
nh          # Nix helper
nix-output-monitor  # Better build output
nvd         # Nix version diff

# Modern CLI replacements
bat         # cat replacement
eza         # ls replacement  
fd          # find replacement
ripgrep     # grep replacement
zoxide      # cd replacement
btop        # top replacement

# Terminal multiplexer
zellij

# File managers
yazi        # Terminal file manager
superfile   # Modern file manager

# Editors
zed-editor
micro
neovim
```

### Maintenance Commands
```bash
# Garbage collection (runs automatically hourly)
nix-collect-garbage

# Optimize nix store (runs automatically)
nix-store --optimise

# Show disk usage
nix path-info -Sh /run/current-system
```

## Configuration Patterns

### Adding New Packages
Add to `environment.systemPackages` in `configuration.nix`:
```nix
# For stable packages
packageName

# For unstable packages  
unstablePkgs.packageName
```

### Modular Configuration
Each `.nix` module follows this pattern:
```nix
{ config, pkgs, ... }: {
  # Configuration here
}
```

### Flake Input Management
Inputs are defined in `flake.nix` and passed via `specialArgs` to make them available in modules.

## System Maintenance

- Automatic garbage collection runs hourly, keeping items newer than 10 days
- Boot loader limited to 10 generations to save space
- Automatic store optimization enabled
- Hardware configuration excluded from git to prevent conflicts

## Notes

- Uses unstable packages for latest versions of development tools
- COSMIC desktop is in alpha - expect some rough edges
- Tailscale configured for VPN access
- ZFS support enabled for advanced filesystem features
- Dotfiles managed separately via chezmoi (not part of this config)
