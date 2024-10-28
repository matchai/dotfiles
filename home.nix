{ pkgs, lib, ... }:

{
  imports = [ ./shell.nix ./git ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    htop
    lunarvim

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
    lib.strings.concatLines [ "@antfu/ni" "playwright" ];
}
