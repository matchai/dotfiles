# Matan's Personal Dotfiles

A fully declarative Nix configuration for my laptop.

## Getting up and running

1. Install Determinate Nix via the installer: https://docs.determinate.systems/

2. Use `nix` to run the first `nix-darwin` build:

```sh
sudo nix run nix-darwin -- switch --flake ~/.config/nixpkgs
```

3. Run future builds using `nix-darwin` directly:

```sh
sudo darwin-rebuild switch --flake ~/.config/nixpkgs
```

**Todo**

- [x] Manage nix packages
- [x] Manage mise runtimes
- [x] Manage brew packages
- [x] Manage mas packages
- [x] Manage macOS defaults configuration
- [ ] Manage dmgs directly downloaded
