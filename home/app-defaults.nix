{ config, ... }:

{
  targets.darwin.defaults = {
    # iTerm2: load prefs from the nix-managed files directory
    "com.googlecode.iterm2" = {
      PrefsCustomFolder = "${config.home.homeDirectory}/.config/nixpkgs/files/iterm2";
      LoadPrefsFromCustomFolder = true;
    };

    # Display Finder in list view by default
    "com.apple.finder".FXPreferredViewStyle = "Nlsv";

    # Menu bar clock: hide date (shown in Fantastical), show day of week and AM/PM
    "com.apple.menuextra.clock" = {
      ShowDate = 2;
      ShowDayOfWeek = true;
      ShowAMPM = true;
    };

    # Disable the "reveal desktop" feature when clicking on the desktop
    # No gaps between tiled windows
    "com.apple.WindowManager" = {
      EnableStandardClickToShowDesktop = false;
      EnableTiledWindowMargins = false;
    };

    # New documents in TextEdit are plain text
    "com.apple.TextEdit".RichText = false;
  };
}
