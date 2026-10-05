{ config, ... }:

{
  # Out-of-store symlink keeps the file writable, so herdr's settings UI can still save.
  xdg.configFile."herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/home/herdr.toml";
}
