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
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nix-homebrew,
      homebrew-core,
      homebrew-bundle,
      homebrew-cask,
      nixpkgs,
    }:
    let
      user = "matchai";
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [ pkgs.vim ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # # Create /etc/zshrc that loads the nix-darwin environment.
          # programs.zsh.enable = true; # default shell on catalina
          programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.config.allowUnfree = true;

          # nixpkgs.overlays =
          #   # Apply each overlay found in the /overlays directory
          #   let path = ./overlays;
          #   in with builtins;
          #   map (n: import (path + ("/" + n))) (filter (n:
          #     match ".*\\.nix" n != null
          #     || pathExists (path + ("/" + n + "/default.nix")))
          #     (attrNames (readDir path)));

          users.users.${user} = {
            home = "/Users/${user}";
          };
        };
    in
    {
      darwinConfigurations."Matans-MacBook-Air" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = user;
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

          ./home.nix
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Matans-MacBook-Air".pkgs;
    };
}
