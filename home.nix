{ pkgs, lib, ... }:

let user = "matchai";
in {
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
    };

    brews = import ./apps/brews.nix;
    casks = import ./apps/casks.nix;
    masApps = import ./apps/mas.nix;
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${user} = {
      imports = [ ./shell.nix ./git ];

      home.stateVersion = "24.05";

      home.packages = pkgs.callPackage ./apps/packages.nix { };

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
    };
  };
}
