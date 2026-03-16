{ config, ... }:

{
  system.defaults = {
    dock = {
      tilesize = 48;
      autohide-time-modifier = 0.7;
      autohide = true;
      show-recents = false;
      persistent-apps = [ ];
      persistent-others = [ "${config.users.users.${config.system.primaryUser}.home}/Downloads" ];

      # Disable hot corners
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };

    finder = {
      # Open Finder in the home directory by default
      NewWindowTarget = "Home";
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

      # Auto-switch between light and dark mode
      AppleInterfaceStyleSwitchesAutomatically = true;

      # Disable "Natural Scrolling" (i.e. scroll the page, rather than the scrollbar)
      "com.apple.swipescrolldirection" = true;
    };

    # Keys not in nix-darwin's typed NSGlobalDomain schema
    CustomSystemPreferences.NSGlobalDomain = {
      # Disable "shake mouse to locate cursor"
      CGDisableCursorLocationMagnification = true;
    };
  };
}
