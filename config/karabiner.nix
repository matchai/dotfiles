{ pkgs, user, ... }:

let
  karabinerConfig = {
    profiles = [
      {
        name = "Default profile";
        selected = true;

        complex_modifications = {
          rules = [
            {
              description = "Tap Caps Lock to Escape, hold for Control";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "caps_lock";
                    modifiers = {
                      optional = [ "any" ];
                    };
                  };
                  to = [
                    {
                      key_code = "left_control";
                      lazy = true;
                    }
                  ];
                  to_if_alone = [ { key_code = "escape"; } ];
                }
              ];
            }
          ];
        };

        virtual_hid_keyboard = {
          keyboard_type_v2 = "ansi";
        };
      }
    ];
  };

  # Generate the Karabiner config JSON file.
  karabinerJsonFile = pkgs.writeText "karabiner-config.json" (builtins.toJSON karabinerConfig);

  # Karabiner requires the config dir to be the symlink, not the file.
  karabinerDir = pkgs.linkFarm "karabiner-config-dir" [
    {
      name = "karabiner.json";
      path = karabinerJsonFile;
    }
  ];

in
{
  homebrew.casks = [ "karabiner-elements" ];

  home-manager.users.${user} = {
    xdg.configFile."karabiner" = {
      source = karabinerDir;
    };
  };
}
