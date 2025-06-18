{ config, ... }:

{
  system.defaults = {
    dock = {
      tilesize = 48;
      autohide-time-modifier = 0.7;
      autohide = true;
      show-recents = false;
      persistent-apps = [];
      persistent-others = [ "/Users/${config.system.primaryUser}/Downloads" ];
    };

    NSGlobalDomain = {
      # Disable the press-and-hold feature for accented characters
      ApplePressAndHoldEnabled = false;

      # Speed up the key repeat rate
      InitialKeyRepeat = 15;
      KeyRepeat = 2;

      # Disable "Natural Scrolling" (i.e. scroll the page, rather than the scrollbar)
      "com.apple.swipescrolldirection" = false;
    };
  };
}
