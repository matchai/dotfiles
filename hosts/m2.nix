{ config, ... }:

{
  homebrew = {
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      # On the M4, Iru (MDM) manages these.
      "1password"
      "raycast"

      # Personal
      "crossover"
    ];
  };
}
