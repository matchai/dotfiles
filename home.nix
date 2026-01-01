{ user, hostname, inputs, ... }:

let
  commonCasks = import ./apps/casks.nix;
  hostCasksFile = ./apps/hosts/${hostname}/casks.nix;
  hostCasks = if builtins.pathExists hostCasksFile then import hostCasksFile else [ ];

  commonBrews = import ./apps/brews.nix;
  hostBrewsFile = ./apps/hosts/${hostname}/brews.nix;
  hostBrews = if builtins.pathExists hostBrewsFile then import hostBrewsFile else [ ];

  commonMasApps = import ./apps/mas.nix;
  hostMasAppsFile = ./apps/hosts/${hostname}/mas.nix;
  hostMasApps = if builtins.pathExists hostMasAppsFile then import hostMasAppsFile else [ ];
in
{
  nix.enable = false;
  system.primaryUser = user;

  imports = [
    ./config/defaults.nix
    ./config/karabiner.nix
    ./config/iterm2
  ];

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    brews = import ./apps/brews.nix;
    casks = commonCasks ++ hostCasks;
    # Disable until mas v4 is released
    # masApps = import ./apps/mas.nix;
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit hostname inputs; };

    users.${user} = {
      imports = [
        ./shell.nix
        ./git
        ./config/ssh.nix
        ./config/claude.nix
        ./apps/packages.nix
      ];
      home.stateVersion = "24.05";
    };
  };
}
