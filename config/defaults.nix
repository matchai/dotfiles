{ config, user, ... }:

{
  system.defaults = {
    dock = {
      tilesize = 48;
      autohide-time-modifier = 0.7;
      autohide = true;
      show-recents = false;
      persistent-apps = [ ];
      persistent-others = [ "/Users/${config.system.primaryUser}/Downloads" ];
    };

    NSGlobalDomain = {
      # Disable the press-and-hold feature for accented characters
      ApplePressAndHoldEnabled = false;
      # Enable keyboard navigation to move focus between controls
      AppleKeyboardUIMode = 2;

      # Disable the automatic capitalization of words
      NSAutomaticCapitalizationEnabled = false;
      # Disable the automatic period substitution
      NSAutomaticPeriodSubstitutionEnabled = false;
      # Disable the automatic quote substitution
      NSAutomaticQuoteSubstitutionEnabled = false;
      # Disable the automatic dash substitution
      NSAutomaticDashSubstitutionEnabled = false;
      # Disable the automatic spelling correction
      NSAutomaticSpellingCorrectionEnabled = false;

      # Speed up the key repeat rate
      InitialKeyRepeat = 15;
      KeyRepeat = 2;

      # Disable "Natural Scrolling" (i.e. scroll the page, rather than the scrollbar)
      "com.apple.swipescrolldirection" = false;
    };
  };

  # User-specific defaults
  home-manager.users.${user}.targets.darwin.defaults = {
    # Hide the date from the menu bar clock. It's shown in Fantastical's icon
    "com.apple.menuextra.clock" = {
      ShowDate = 2;
    };

    # New documents in TextEdit are plain text
    "com.apple.TextEdit" = {
      RichText = false;
    };
  };
}
