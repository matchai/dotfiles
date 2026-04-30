{
  npmPackages = [ "vercel" ];

  darwin =
    { config, ... }:
    {
      homebrew = {
        taps = builtins.attrNames config.nix-homebrew.taps ++ [ "datadog-labs/pack" ];
        brews = [ "datadog-labs/pack/pup" ];
        casks = [
          # Browsers
          "thebrowsercompany-dia"

          # Productivity
          "chatgpt"
          "granola"
          "linear-linear"
          "loom"
          "notion-calendar"
          "slack"
          "nordlayer"
        ];
      };
    };
}
