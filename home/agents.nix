{ config, ... }:

let
  repoPath = "${config.home.homeDirectory}/.config/nixpkgs";
  filesPath = "${repoPath}/files";
  symlink = config.lib.file.mkOutOfStoreSymlink;

  dirNames = path: builtins.attrNames (builtins.readDir path);

  localSkillNames = dirNames ../files/skills;
  managedSkillNames = builtins.attrNames (builtins.fromJSON (builtins.readFile ../skills-lock.json))
    .skills;
  skillNameCollisions = builtins.filter (name: builtins.elem name managedSkillNames) localSkillNames;
  commands = dirNames ../files/commands;

  localSkillLinks = builtins.listToAttrs (
    builtins.map (name: {
      name = ".agents/skills/${name}";
      value.source = symlink "${filesPath}/skills/${name}";
    }) localSkillNames
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
  assertions = [
    {
      assertion = skillNameCollisions == [ ];
      message = "Skills cannot be both local and managed: ${builtins.concatStringsSep ", " skillNameCollisions}";
    }
  ];

  home.file = {
    # Project-scoped skills CLI state. Running `skills` from $HOME restores managed
    # skills beside the local Home Manager links in ~/.agents/skills.
    "skills-lock.json".source = symlink "${repoPath}/skills-lock.json";

    # Shared instructions (AGENTS.md convention, symlinked as CLAUDE.md for Claude Code)
    "AGENTS.md".source = symlink "${filesPath}/instructions.md";
    ".claude/CLAUDE.md".source = symlink "${filesPath}/instructions.md";
    ".config/opencode/AGENTS.md".source = symlink "${filesPath}/instructions.md";

    # Shared rules (deployed to .claude/rules/, read by both via oh-my-opencode)
    ".claude/rules".source = symlink "${filesPath}/rules";

    # OpenCode-specific config
    ".config/opencode/opencode.jsonc".source = symlink "${filesPath}/opencode/opencode.jsonc";
    ".cmuxterm/omo-config/openagent.jsonc".source = symlink "${filesPath}/opencode/opencode.jsonc";
  }
  // localSkillLinks
  // commandLinks;

}
