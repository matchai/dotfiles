{
  user,
  hostname,
  ...
}:

let
  commonCasks = import ./apps/casks.nix;
  # Load host-specific casks if they exist
  hostCasksFile = ./apps/hosts/${hostname}/casks.nix;
  hostCasks = if builtins.pathExists hostCasksFile then import hostCasksFile else [ ];
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
    masApps = import ./apps/mas.nix;
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${user} = {
      imports = [
        ./shell.nix
        ./git
        ./config/ssh.nix
        ./apps/packages.nix
      ];
      home.stateVersion = "24.05";
    };
  };
}
