{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    brews = [ "macos-trash" ];

    casks = [
      # macOS Must-Haves
      "appcleaner"
      "flux-app"
      "jordanbaird-ice@beta"
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
      "cursor"
      "cyberduck"
      "dash"
      "ghostty"
      "iterm2"
      "orbstack"
      "tableplus"
      "yaak"
      "zed"

      # Fonts
      "font-fira-code-nerd-font"

      # Personal
      "1password"
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
      "mullvad-vpn"
      "replacicon"

      # Productivity
      "notion"
      "voiceink"
    ];
  };
}
