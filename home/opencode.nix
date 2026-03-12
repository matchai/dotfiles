{ config, pkgs, ... }:

let
  claudeConfigPath = "${config.home.homeDirectory}/.config/nixpkgs/files/claude";
  opencodeConfigPath = "${config.home.homeDirectory}/.config/nixpkgs/files/opencode";
in
{
  home.file.".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/CLAUDE.md";
  home.file.".claude/rules".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/rules";
  home.file.".config/opencode/opencode.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${opencodeConfigPath}/opencode.jsonc";
  home.file.".config/opencode/oh-my-opencode.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${opencodeConfigPath}/oh-my-opencode.jsonc";

  home.activation.claudeMcp = config.lib.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD /opt/homebrew/bin/op inject -f -i ${claudeConfigPath}/mcp.json -o ~/.claude/.mcp.json || echo "WARNING: op inject failed -- ~/.claude/.mcp.json not updated"
    $DRY_RUN_CMD rm -f ~/.config/opencode/.mcp.json
  '';
}
