{ self, nixpkgs, nix-darwin, home-manager, nix-homebrew
, homebrew-core, homebrew-cask, homebrew-bundle, ... }@inputs:

hostId:
let
  user = "matchai";
  hostConfig = import ../hosts/${hostId}.nix;
  npmPackages = hostConfig.npmPackages or [];
in
nix-darwin.lib.darwinSystem {
  specialArgs = { inherit self inputs user; };
  modules = [
    ../modules/darwin
    hostConfig.darwin

    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        extraSpecialArgs = { inherit inputs user npmPackages; };
        users.${user} = import ../home;
      };
    }

    nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        inherit user;
        taps = {
          "homebrew/homebrew-core" = homebrew-core;
          "homebrew/homebrew-cask" = homebrew-cask;
          "homebrew/homebrew-bundle" = homebrew-bundle;
        };
        mutableTaps = false;
        autoMigrate = true;
      };
    }
  ];
}
