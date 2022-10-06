{ config, pkgs, ... }:

{
  # ----- General UI/UX -----

  # Expand save panel by default
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

  # Expand print panel by default
  system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
  system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;

  # Save to disk (not to iCloud) by default
  system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = true;

  # Disable the “Are you sure you want to open this application?” dialog
  system.defaults.LaunchServices.LSQuarantine = false;

  # Disable automatic termination of inactive apps
  system.defaults.NSGlobalDomain.NSDisableAutomaticTermination = true;

  # ----- Mouse and Keyboard -----

  # Disable automatic capitalization as it’s annoying when typing code
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;

  # Disable smart dashes as they’re annoying when typing code
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;

  # Disable automatic period substitution as it’s annoying when typing code
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;

  # Disable smart quotes as they’re annoying when typing code
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;

  # Disable auto-correct
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;

  # Disable “natural” (Lion-style) scrolling
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

  # Enable full keyboard access for all controls
  # (e.g. enable Tab in modal dialogs)
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;

  # Disable press-and-hold for keys in favor of key repeat
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  # Set a blazingly fast keyboard repeat rate
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;

  # ----- Dock ----

  # Automatically hide and show the dock
  system.defaults.dock.autohide = true;
  # Don't show recent applications in the dock
  system.defaults.dock.show-recents = false;
}
