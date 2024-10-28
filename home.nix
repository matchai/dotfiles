{ pkgs, ... }:

{
  imports = [ ./shell.nix ./git ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    htop

    # Nix related
    nil
    nixfmt
  ];
}
