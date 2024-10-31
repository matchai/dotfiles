_:

let
  user = "matchai";
in
{
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
      imports = [
        ./shell.nix
        ./git
        ./apps/packages.nix
      ];
      home.stateVersion = "24.05";
    };
  };
}
