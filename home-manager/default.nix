{ config, pkgs, ... }:

{
  imports = [ ./shell.nix ./neovim.nix ./git ];

  home.packages = with pkgs; [
    home-manager

    bat # fancy version of `cat`
    cargo-edit
    fd # fancy version of `find`
    exa # fancy version of `ls`
    htop # fancy version of `top`
    hyperfine # benchmarking tools
    mosh # fancy version of `ssh`
    procs # fancy version of `ps`
    ripgrep # fancy version of `grep`
    rustup # rust version manager
    tealdeer # rust implementation of `tldr`
  ] ++ lib.optionals stdenv.isDarwin [
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
  home.stateVersion = "20.09";
}
