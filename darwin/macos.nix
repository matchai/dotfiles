{ config, pkgs, ... }:

{
  # Automatically hide and show the dock
  system.defaults.dock.autohide = true;
  # Don't show recent applications in the dock
  system.defaults.dock.show-recents = false;

  # Enable full keyboard access for all controls
  # (e.g. enable Tab in modal dialogs)
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;

  # Set key repeat rate
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
}
