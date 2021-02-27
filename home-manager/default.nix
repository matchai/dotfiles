{ config, pkgs, ... }:

{
  imports = [ ./shell.nix ./neovim.nix ./git ];

  home.packages = with pkgs; [
    home-manager

    bat
    cargo-edit
    fd
    fzf
    exa
    git-chglog
    htop
    jump
    mosh
    ripgrep
    rustup
    tealdeer
    unzip
    yadm
    zip
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
