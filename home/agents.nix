{ config, ... }:

let
  repoPath = "${config.home.homeDirectory}/.config/nixpkgs";
  filesPath = "${repoPath}/files";
  # Gitignored, so flake evaluation cannot read it; activation links it instead.
  localOnlySkillsPath = "${filesPath}/skills-local";
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

  # Link skills that must stay out of git, such as ones naming internal projects.
  home.activation.linkLocalOnlySkills = config.lib.dag.entryAfter [ "linkGeneration" ] ''
    skillsDir="$HOME/.agents/skills"
    localOnlyDir="${localOnlySkillsPath}"
    run mkdir -p "$skillsDir"

    for link in "$skillsDir"/*; do
      [ -L "$link" ] || continue
      target="$(readlink "$link")"
      case "$target" in
        "$localOnlyDir"/*) [ -e "$target" ] || run rm "$link" ;;
      esac
    done

    for skill in "$localOnlyDir"/*/; do
      [ -d "$skill" ] || continue
      name="$(basename "$skill")"
      link="$skillsDir/$name"
      if [ -e "$link" ] || [ -L "$link" ]; then
        if [ "$(readlink "$link")" != "$localOnlyDir/$name" ]; then
          errorEcho "Local-only skill $name collides with existing $link"
          exit 1
        fi
      fi
      run ln -sfn "$localOnlyDir/$name" "$link"
    done
  '';

  home.file = {
    # Project-scoped skills CLI state. Running `skills` from $HOME restores managed
    # skills beside the local Home Manager links in ~/.agents/skills.
    "skills-lock.json".source = symlink "${repoPath}/skills-lock.json";

    # Keep Codex's legacy skills path on the same local and installed skill versions.
    ".codex/skills" = {
      source = symlink "${config.home.homeDirectory}/.agents/skills";
      force = true;
    };

    # Keep Claude Code on the same local and installed skill versions.
    ".claude/skills" = {
      source = symlink "${config.home.homeDirectory}/.agents/skills";
      force = true;
    };

    # Shared instructions (AGENTS.md convention, symlinked as CLAUDE.md for Claude Code)
    "AGENTS.md".source = symlink "${filesPath}/instructions.md";
    ".claude/CLAUDE.md".source = symlink "${filesPath}/instructions.md";
    ".config/opencode/AGENTS.md".source = symlink "${filesPath}/instructions.md";

    # Shared rules (deployed to .claude/rules/, read by both via oh-my-opencode)
    ".claude/rules".source = symlink "${filesPath}/rules";

    # OpenCode-specific config
    ".config/opencode/opencode.jsonc".source = symlink "${filesPath}/opencode/opencode.jsonc";
  }
  // localSkillLinks
  // commandLinks;

}
