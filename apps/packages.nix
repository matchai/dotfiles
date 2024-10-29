{ pkgs }:

with pkgs; [
  # CLIs
  bat # fancy version of `cat`
  fd # fancy version of `find`
  eza # fancy version of `ls`
  # Blocked by https://nixpk.gs/pr-tracker.html?pr=350035
  # mosh # fancy version of `ssh`
  ripgrep # fancy version of `grep`
  procs # fancy version of `ps`
  bottom # fancy version of `top`
  lunarvim # pre-configured vim
  tealdeer # rust implementation of `tldr`

  # Workflow
  _1password
  doctl

  # Nix related
  nil
  nixfmt
]