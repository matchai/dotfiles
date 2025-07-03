{ pkgs, ... }:

{
  home.packages = with pkgs.gitAndTools; [
    diff-so-fancy
    gitui
    tig
    gh
  ];

  programs.git = {
    enable = true;
    userName = "Matan Kushner";
    userEmail = "hello@matchai.dev";

    lfs.enable = true;

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDOcOl6AP6NpB+MnMLhpEJkC2XvEEMq4aJ8j06ltily9";
      signByDefault = true;
    };

    ignores = [
      ".cache/"
      ".DS_Store"
      ".idea/"
      "*.swp"
      "npm-debug.log*"
      "yarn-debug.log*"
      "yarn-error.log*"
      ".pnpm-debug.log*"
    ];

    aliases = {
      l = "log --pretty=oneline -n 50 --graph --abbrev-commit";
      save = "!git add -A && git commit -v -m 'SAVEPOINT'";
      undo = "reset HEAD~1 --mixed";
      root = "rev-parse --show-toplevel";
      wipe = "!git add -A && git commit --no-gpg-sign -qm 'WIPE SAVEPOINT' --no-verify && git reset HEAD~1 --hard";
      findcommit = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f";
      findmessage = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f";

      # gh aliases
      sync = "!gh repo sync";
      browse = "!gh browse";
      cl = "!f() { gh repo clone $1; }; f";
    };

    extraConfig = {
      # SSH signing
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

      commit.template = builtins.toPath ./git-message;

      core = {
        editor = "lvim";
        pager = "diff-so-fancy | less --tabs=4 -RFX";
      };

      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };

      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };

      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };

      init.defaultBranch = "main";
      branch.sort = "-committerdate";
      pull.rebase = true;
      color.ui = true;

      "color \"diff-highlight\"" = {
        oldNormal = "red bold";
        oldHighlight = "red bold 52";
        newNormal = "green bold";
        newHighlight = "green bold 22";
      };

      "color \"diff\"" = {
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
        whitespace = "red reverse";
      };
    };
  };}
