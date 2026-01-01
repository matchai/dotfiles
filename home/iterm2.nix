{ user, ... }:

{
  targets.darwin.defaults."com.googlecode.iterm2" = {
    PrefsCustomFolder = "/Users/${user}/.config/nixpkgs/files/iterm2";
    LoadPrefsFromCustomFolder = true;
  };
}
