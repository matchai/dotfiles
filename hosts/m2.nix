{
  npmPackages = [ ];

  darwin =
    { config, ... }:
    {
      homebrew = {
        taps = builtins.attrNames config.nix-homebrew.taps;
        casks = [
          # Personal
          "crossover"
        ];
      };
    };
}
