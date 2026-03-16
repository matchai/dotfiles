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

    # Hide the date from the menu bar clock. It's shown in Fantastical's icon
    "com.apple.menuextra.clock".ShowDate = 2;

    # Disable the "reveal desktop" feature when clicking on the desktop
    "com.apple.WindowManager".EnableStandardClickToShowDesktop = false;

    # New documents in TextEdit are plain text
    "com.apple.TextEdit".RichText = false;
  };
}
