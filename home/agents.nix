{ config, ... }:

let
  repoPath = "${config.home.homeDirectory}/.config/nixpkgs";
  filesPath = "${repoPath}/files";
  symlink = config.lib.file.mkOutOfStoreSymlink;

  dirNames = path: builtins.attrNames (builtins.readDir path);

  commands = dirNames ../files/commands;

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
  # Your skills live in files/skills (public) and in ~/second-brain/skills, a checkout of the
  # private matchai/second-brain. link-skills.sh links both into ~/.agents/skills, so a skill
  # added to either appears without a switch.
  home.activation.linkSkills = config.lib.dag.entryAfter [ "linkGeneration" ] ''
    [ -d "$HOME/second-brain" ] || warnEcho "Clone matchai/second-brain to ~/second-brain for your private skills"
    run "${filesPath}/link-skills.sh"
  '';

  home.file = {
    # Project-scoped skills CLI state. Running `skills` from $HOME restores managed
    # skills beside the links files/link-skills.sh makes in ~/.agents/skills.
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
    ".fx/AGENTS.md".source = symlink "${filesPath}/instructions.md";

    # OpenCode-specific config
    ".config/opencode/opencode.jsonc".source = symlink "${filesPath}/opencode/opencode.jsonc";
  }
  // commandLinks;

}
