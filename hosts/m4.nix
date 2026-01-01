{
  npmPackages = [ "vercel" ];

  darwin = { config, ... }: {
    homebrew = {
      taps = builtins.attrNames config.nix-homebrew.taps;
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
      ];
    };
  };
}
