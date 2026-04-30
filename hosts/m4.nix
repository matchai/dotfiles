{
  npmPackages = [ "vercel" ];

  home =
    { config, ... }:
    {
      home.activation = {
        # Install Datadog skills via pup (DD_ACCESS_TOKEN=skip bypasses keychain prompt)
        installPupSkills = config.lib.dag.entryAfter [ "writeBoundary" ] ''
          $DRY_RUN_CMD env DD_ACCESS_TOKEN=skip /opt/homebrew/bin/pup skills install --target-agent=opencode
        '';
      };
    };

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
