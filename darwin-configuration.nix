{ config, pkgs, ... }:

let mainUser = "matchai";
in {
  imports = [ ./darwin <home-manager/nix-darwin> ];

  users.users.${mainUser} = {
    home = "/Users/${mainUser}";
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
  
  home-manager = {
    users.${mainUser} = import ./home;
    useGlobalPkgs = true;
    useUserPackages = false;
  };

  services.nix-daemon.enable = true;
  nix.useDaemon = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
