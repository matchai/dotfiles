{ config, ... }:

{
  system.defaults.dock = {
    tilesize = 48;
    autohide-time-modifier = 0.7;
    autohide = true;
    show-recents = false;
    persistent-apps = [];
    persistent-others = [ "/Users/${config.system.primaryUser}/Downloads" ];
  };
}
