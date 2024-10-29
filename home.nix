{ pkgs, lib, ... }:

{
  imports = [ ./shell.nix ./git ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
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
  ];

  # Setup dev tool version manager
  programs.mise = {
    enable = true;
    globalConfig.tools = {
      node = "lts";
      usage = "latest";
    };
  };

  # Have some default packages pre-installed
  home.file.".default-npm-packages".text =
    lib.strings.concatLines [ "@antfu/ni" "playwright" "prettier" ];
}
