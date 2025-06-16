{
  self,
  pkgs,
  user,
  ...
}:

{
  # List packages installed in system profile.
  environment.systemPackages = [ pkgs.vim ];
  environment.shells = [ pkgs.fish ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable and set the default shell
  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.fish;
    uid = 501;
  };
}
