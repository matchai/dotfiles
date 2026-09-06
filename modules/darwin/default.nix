{
  config,
  self,
  pkgs,
  user,
  ...
}:

let
  home = "/Users/${user}";
  systemPath = builtins.replaceStrings [ "$HOME" ] [ home ] config.environment.systemPath;
  guiPath = pkgs.lib.concatStringsSep ":" (
    pkgs.lib.unique (
      [
        "${home}/.local/share/mise/shims"
        "${home}/.local/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
      ]
      ++ pkgs.lib.splitString ":" systemPath
    )
  );
in
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

  environment.systemPackages = [ pkgs.neovim ];
  environment.shells = [ pkgs.fish ];

  programs.fish.enable = true;

  # GUI apps launched by launchd do not inherit interactive Fish init. Put Mise
  # shims on the launchd PATH so Codex Desktop and other apps resolve local tools.
  launchd.user.envVariables.PATH = guiPath;

  # Use Touch ID for sudo authentication
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true; # Works in tmux/screen
  };

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.fish;
  };
}
