{ config, ... }:

let
  filesPath = "${config.home.homeDirectory}/.config/nixpkgs/files";
  symlink = config.lib.file.mkOutOfStoreSymlink;

  dirNames = path: builtins.attrNames (builtins.readDir path);

  skills = dirNames ../files/skills;
  commands = dirNames ../files/commands;

  skillLinks = builtins.listToAttrs (
    builtins.concatMap (name: [
      {
        name = ".claude/skills/${name}";
        value.source = symlink "${filesPath}/skills/${name}";
      }
      {
        name = ".config/opencode/skills/${name}";
        value.source = symlink "${filesPath}/skills/${name}";
      }
    ]) skills
  );

  commandLinks = builtins.listToAttrs (
    builtins.concatMap (name: [
      {
        name = ".claude/.agents/commands/${name}";
        value.source = symlink "${filesPath}/commands/${name}";
      }
      {
        name = ".config/opencode/command/${name}";
        value.source = symlink "${filesPath}/commands/${name}";
      }
    ]) commands
  );
in
{
  home.file = {
    # Shared instructions (AGENTS.md convention, symlinked as CLAUDE.md for Claude Code)
    "AGENTS.md".source = symlink "${filesPath}/instructions.md";
    ".claude/CLAUDE.md".source = symlink "${filesPath}/instructions.md";
    ".config/opencode/AGENTS.md".source = symlink "${filesPath}/instructions.md";

    # Shared rules (deployed to .claude/rules/, read by both via oh-my-opencode)
    ".claude/rules".source = symlink "${filesPath}/rules";

    # OpenCode-specific config
    ".config/opencode/opencode.jsonc".source = symlink "${filesPath}/opencode/opencode.jsonc";
    ".config/opencode/oh-my-opencode.jsonc".source =
      symlink "${filesPath}/opencode/oh-my-opencode.jsonc";
  }
  // skillLinks
  // commandLinks;

  home.activation = {
    # Install Datadog skills via pup (DD_ACCESS_TOKEN=skip bypasses keychain prompt)
    installPupSkills = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD env DD_ACCESS_TOKEN=skip /opt/homebrew/bin/pup skills install --target-agent=opencode
    '';
  };
}
