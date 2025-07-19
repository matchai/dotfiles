{
  description = "Matan's macOS Nix configuration";

  inputs = {
    # nix-darwin and home-manager
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-homebrew and its taps
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      home-manager,
      nix-homebrew,
      homebrew-core,
      homebrew-bundle,
      homebrew-cask,
      nixpkgs,
      ...
    }:
    let
      user = "matchai";
      lib = nixpkgs.lib;

      # Define the entire system configuration once and store it in a variable.
      mkDarwinSystem = hostname: nix-darwin.lib.darwinSystem {
        # This makes the `user` variable available to all modules.
        specialArgs = { inherit self user hostname lib; };

        modules = [
          # Import the main system configuration
          ./configuration.nix

          # Import modules for home-manager and nix-homebrew
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              inherit user; # Use the user variable defined above
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };
              autoMigrate = true;
              mutableTaps = false;
            };
          }

          # Align homebrew taps with nix-homebrew's taps
          (
            { config, ... }:
            {
              homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            }
          )

          # Import your main home.nix configuration
          ./home.nix
        ];
      };

    in
    {
      darwinConfigurations."Matans-MacBook-Air-M2" = mkDarwinSystem "Matans-MacBook-Air-M2";
      darwinConfigurations."Matans-MacBook-Air-M4" = mkDarwinSystem "Matans-MacBook-Air-M4";

      darwinPackages = (mkDarwinSystem "Matans-MacBook-Air-M2").pkgs;
    };
}
