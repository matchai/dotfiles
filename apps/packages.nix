{ pkgs }:

with pkgs; [
  # CLIs
  bat # fancy version of `cat`
  fd # fancy version of `find`
  eza # fancy version of `ls`
  ripgrep # fancy version of `grep`
  procs # fancy version of `ps`
  bottom # fancy version of `top`
  lunarvim # pre-configured vim
  tealdeer # rust implementation of `tldr`

  # Blocked by https://nixpk.gs/pr-tracker.html?pr=350035
  # mosh # fancy version of `ssh`

  # macOS
  mas
  duti

  # Workflow
  _1password # The CLI for 1Password
  doctl

  # Nix related
  nil
  nixfmt
]
