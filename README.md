# Matan's Dotfiles

My fully-declarative system configuration using Nix and Nix-Darwin.

## Installation

Run at your own risk:
```sh
curl -fsSL https://raw.githubusercontent.com/matchai/dotfiles/main/install | bash
```

## Goals

- [x] Installs Command Line Tools silently
- [x] Installs Nix
- [x] Installs Nix-Darwin
- [x] Installs Homebrew
- [x] Clones this repo to the local machine
- [x] Initiates the first `darwin-rebuild` to switch configurations

## Layout
- `darwin/` - Darwin-specific configuration
- `home/` - Home-manager configuration and dotfile management

## Inspiration

Heavily inspired by:
- https://github.com/burke/b
- https://github.com/maksar/dotfiles
- https://github.com/malob/nixpkgs
- https://github.com/TheOptimist/systemosaurus
