{ self, pkgs, user, ... }:

{
  imports = [
    ./defaults.nix
    ./homebrew.nix
  ];

  # Using Determinate Nix installer
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = user;
  system.stateVersion = 6;
  system.configurationRevision = self.rev or self.dirtyRev or null;

  environment.systemPackages = [ pkgs.vim ];
  environment.shells = [ pkgs.fish ];

  programs.fish.enable = true;

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.fish;
  };
}
