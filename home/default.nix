{ config, pkgs, ... }:

{
  imports = [
    ./git
    ./shell.nix
  ];

  home.packages = with pkgs; [
    # CLIs
    cargo-edit # project package management with cargo
    git-chglog # changelog generation
    glow # markdown preview
    hexyl # hex viewer
    hyperfine # benchmarking tools
    ncdu # disk usage
    watchman # file watching
    wget # download files
    tokei # code metrics
    tmux # terminal multiplexer

    # CLIs but better
    bat # fancy version of `cat`
    fd # fancy version of `find`
    eza # fancy version of `ls`
    htop # fancy version of `top`
    mosh # fancy version of `ssh`
    procs # fancy version of `ps`
    ripgrep # fancy version of `grep`
    dogdns # fancy version of `dig`
    broot # fancy version of `tree`
    duf # fancy version of `df`
    du-dust # fancy version of `du`
    bottom # fancy version of `top`
    tealdeer # rust implementation of `tldr`

    # Languages
    yarn
    rustup
    go
    elixir
    stylua

    # Nix-related
    home-manager # system package manager
    comma # any cli you may need

  ] ++ (with nodePackages; [
    # NPM Packages
    neovim # neovim nodejs provider
    prettier # code formatter

  ]) ++ lib.optionals stdenv.isDarwin [
    m-cli # useful macos CLI commands

  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}
