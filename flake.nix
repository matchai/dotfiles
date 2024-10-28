{
  description = "Matan's personal macOS Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, nix-homebrew, homebrew-core, homebrew-cask }: 
    let user = "matchai"; in
    {
      darwinConfigurations."Matans-MacBook-Air" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            useGlobalPkgs = true;
            users.${user} = import ./home.nix;
          }
        ]

      # modules = [
      #   ./configuration.nix
      #   ./darwin.nix
      #   home-manager.darwinModules.home-manager
      #   nix-homebrew.darwinModules.nix-homebrew
      #   {
      #     nix-homebrew = {
      #       enable = true;
      #       taps = {
      #         "homebrew/homebrew-core" = homebrew-core;
      #         "homebrew/homebrew-cask" = homebrew-cask;
      #       };
      #       mutableTaps = false;
      #       autoMigrate = true;
      #     };
      #   }
      # ];
    };
  }
}
