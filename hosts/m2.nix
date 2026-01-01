{
  npmPackages = [ ];

  darwin = { config, ... }: {
    homebrew = {
      taps = builtins.attrNames config.nix-homebrew.taps;
      casks = [
        # Development
        "zed"

        # Personal
        "crossover"
        "deskpad"
        "jdownloader"
        "syncthing-app"
      ];
    };
  };
}
