{ config, pkgs, ... }:

let
  claudeConfigPath = "${config.home.homeDirectory}/.config/nixpkgs/files/claude";
in
{
  home.file.".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/CLAUDE.md";
  home.file.".claude/rules".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/rules";

  home.activation.claudeMcp = config.lib.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs._1password-cli}/bin/op inject -f -i ${claudeConfigPath}/mcp.json -o ~/.claude/.mcp.json
  '';
}
