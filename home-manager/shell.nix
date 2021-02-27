{ config, pkgs, ... }:

let
  shellAliases = {
    # Apps... but better
    git = "hub";
    vim = "nvim";
    ls = "exa";
    cat = "bat";
    find = "fd";

    # ls
    l = "ls -l";
    ll = "ls -la";

    # misc
    tree = "exa --tree";
    reload = "exec fish";
    oo = "open .";
  };

  shellAbbrs = {
    gs = "git status -sb";
    ga = "git add";
    gc = "git commit";
    gcm = "git commit -m";
    gca = "git commit --amend";
    gcl = "git clone";
    gco = "git checkout";
    gp = "git push";
    gpl = "git pull";
    gl = "git l";
    gd = "git diff";
    gds = "git diff --staged";
    gr = "git rebase -i HEAD~15";
    gf = "git fetch";
    gfc = "git findcommit";
    gfm = "git findmessage";
  };
in {
  programs.fish = {
    inherit shellAliases shellAbbrs;
    enable = true;

    interactiveShellInit = "source (jump shell fish | psub)";
    shellInit = "eval (/opt/homebrew/bin/brew shellenv)";

    plugins = [
      {
        name = "fish-colored-man";
        src = pkgs.fetchFromGitHub {
          owner = "decors";
          repo = "fish-colored-man";
          rev = "master";
          sha256 = "16ar220pz8lmv58c8fj81mi7slk0qb20dh5zdwcyyw12dgzahsvr";
        };
      }
    ];
  };

  programs.zsh = {
    inherit shellAliases;
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.extended = true;
  };

  programs.starship.enable = true;
}
