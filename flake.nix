{
  description = "Matan's macOS Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-datadog-pack = {
      url = "github:datadog-labs/homebrew-pack";
      flake = false;
    };
    homebrew-jnsahaj-lumen = {
      url = "github:jnsahaj/homebrew-lumen";
      flake = false;
    };
    homebrew-nkzw-tech = {
      url = "github:nkzw-tech/homebrew-tap";
      flake = false;
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
    in
    {
      darwinConfigurations = {
        "Matans-MacBook-Air-M2" = mkDarwinSystem "m2";
        "Matans-MacBook-Air-M4" = mkDarwinSystem "m4";
      };

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;
    };
}
