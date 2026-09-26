{
  self,
  nixpkgs,
  nix-darwin,
  home-manager,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  homebrew-datadog-pack,
  homebrew-jnsahaj-lumen,
  homebrew-nkzw-tech,
  ...
}@inputs:

hostId:
let
  user = "matchai";
in
nix-darwin.lib.darwinSystem {
  specialArgs = { inherit self inputs user; };
  modules = [
    ../modules/darwin
    ../hosts/${hostId}.nix

    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        extraSpecialArgs = { inherit inputs user; };
        users.${user}.imports = [ ../home ];
      };
    }

    nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        # Already cached in home-manager fish shellInit — no need to eval at startup
        enableFishIntegration = false;
        inherit user;
        taps = {
          "homebrew/homebrew-core" = homebrew-core;
          "homebrew/homebrew-cask" = homebrew-cask;
          "datadog-labs/homebrew-pack" = homebrew-datadog-pack;
          "jnsahaj/homebrew-lumen" = homebrew-jnsahaj-lumen;
          "nkzw-tech/homebrew-tap" = homebrew-nkzw-tech;
        };
        mutableTaps = false;
        autoMigrate = true;
      };
    }
  ];
}
