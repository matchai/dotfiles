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
    glow       # markdown preview
    hexyl      # hex viewer
    hyperfine  # benchmarking tools
    ncdu       # disk usage
    watchman   # file watching
    wget       # download files

    # CLIs but better
    bat      # fancy version of `cat`
    fd       # fancy version of `find`
    exa      # fancy version of `ls`
    htop     # fancy version of `top`
    mosh     # fancy version of `ssh`
    procs    # fancy version of `ps`
    ripgrep  # fancy version of `grep`
    httpie   # fancy version of `curl`
    tealdeer # rust implementation of `tldr`

    # Languages
    nodejs-16_x yarn
    rustup
    go
    elixir
    stylua

    # Nix-related
    home-manager # system package manager

  ] ++ (with nodePackages; [
    # NPM Packages
    neovim    # neovim nodejs provider
    pnpm      # disk-efficient npm
    prettier  # code formatter
    # @antfu/ni # use the right package manager
  ]) ++ lib.optionals stdenv.isDarwin [
    m-cli     # useful macos CLI commands
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
