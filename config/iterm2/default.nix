{ user, ... }:

{
  homebrew = {
    casks = [ "iterm2" ];
  };

  system.defaults.CustomUserPreferences = {
    "com.googlecode.iterm2" = {
      PrefsCustomFolder = "/Users/${user}/.config/nixpkgs/config/iterm2";
      LoadPrefsFromCustomFolder = true;
    };
  };
}
