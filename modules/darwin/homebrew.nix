{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };

    brews = [
      "macos-trash"
      "worktrunk"
      "jnsahaj/lumen/lumen"
      "datadog-labs/pack/pup"
    ];

    taps = [
      "manaflow-ai/cmux"
      "jnsahaj/lumen"
      "datadog-labs/pack"
    ];

    casks = [
      # macOS Must-Haves
      "appcleaner"
      "flux-app"
      "jordanbaird-ice"
      "karabiner-elements"
      "raycast"
      "yellowdot"

      # Browsers
      "arc"
      "firefox"
      "google-chrome"
      "orion"

      # Communication
      "beeper"
      "discord"
      "readdle-spark"
      "whatsapp"
      "zoom"

      # Entertainment
      "iina"
      "steam"
      "stremio"

      # Design
      "ogdesign-eagle"
      "figma"

      # Development
      "cmux"
      "cursor"
      "cyberduck"
      "dash"
      "ghostty"
      "iterm2"
      "orbstack"
      "tableplus"
      "visual-studio-code"
      "yaak"
      "zed"

      # Fonts
      "font-fira-code-nerd-font"
      "1password"
      "1password-cli"
      "anki"
      "betterdisplay"
      "cleanshot"
      "coconutbattery"
      "daisydisk"
      "elgato-control-center"
      "fantastical"
      "imageoptim"
      "keka"
      "kekaexternalhelper"
      "replacicon"

      # Productivity
      "notion"
      "obsidian"
      "voiceink"

      # Personal
      "jdownloader"
    ];
  };
}
