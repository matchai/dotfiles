{ config, ... }:

{
  # Out-of-store symlink keeps the file writable, so `wt config` can still save.
  xdg.configFile."worktrunk/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/home/worktrunk.toml";
}
