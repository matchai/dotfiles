{ config, user, ... }:

{
  homebrew = {
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [
      "datadog-labs/pack/pup"
      "awscli"
    ];
    casks = [
      # Browsers
      "thebrowsercompany-dia"

      # Development
      {
        name = "nkzw-tech/tap/codiff";
        greedy = true;
      }
      "session-manager-plugin"

      # Productivity
      {
        name = "chatgpt";
        greedy = true;
      }
      {
        name = "claude";
        greedy = true;
      }
      "linear"
      "loom"
      "notion-calendar"
      "slack"
      "nordlayer"
    ];
  };

  home-manager.users.${user} =
    { config, pkgs, ... }:
    let
      homeDirectory = config.home.homeDirectory;
      repoPath = "${homeDirectory}/.config/nixpkgs";
      m4SkillsProject = "${homeDirectory}/.local/share/m4-agent-skills";
      publicNpmConfig = pkgs.writeText "public-npmrc" ''
        registry=https://registry.npmjs.org/
      '';
      skillsPath = pkgs.lib.makeBinPath [
        pkgs.git
        pkgs.nodejs
        pkgs.openssh
      ];
      skillsCli = "${pkgs.pnpm}/bin/pnpx skills";
      symlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home.file = {
        # Keep pnpm project discovery here so it does not treat ~/.npmrc as a project-level config.
        ".local/share/m4-agent-skills/package.json".text = builtins.toJSON {
          name = "m4-agent-skills";
          private = true;
        };
        ".local/share/m4-agent-skills/skills-lock.json".source =
          symlink "${repoPath}/hosts/m4-skills-lock.json";
        ".local/share/m4-agent-skills/.agents/skills".source = symlink "${homeDirectory}/.agents/skills";
        ".agents/skills/monthly-perf-checkin".source =
          symlink "${repoPath}/hosts/m4-skills/monthly-perf-checkin";
      };

      # Restore work-machine-only skills from their separate lockfile.
      home.activation.restoreM4Skills = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        cd ${m4SkillsProject}
        run env \
          PATH=${skillsPath}:$PATH \
          NPM_CONFIG_USERCONFIG=${publicNpmConfig} \
          ${skillsCli} experimental_install
      '';
    };
}
