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

  karabinerDir = pkgs.runCommand "karabiner-config-dir" {} ''
    # Create the output directory ($out is a special variable for the store path)
    mkdir -p $out

    cat <<EOF > $out/karabiner.json
    ${builtins.toJSON karabinerConfig}
    EOF
  '';

in
{
  homebrew.casks = [
    "karabiner-elements"
  ];

  home-manager.users.${user} = {
    home.file.".config/karabiner" = {
      source = karabinerDir;
    };
  };
}
