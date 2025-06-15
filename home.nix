_:

let
  user = "matchai";
in
{
  nix.enable = false;

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
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
        ./config/ssh.nix
        ./apps/packages.nix
      ];
      home.stateVersion = "24.05";
    };
  };

  system = {
    primaryUser = user;
    defaults.dock = {
      show-recents = false;
      persistent-apps = [];
      persistent-others = [ "/Users/${user}/Downloads" ];
    };
  };
}
