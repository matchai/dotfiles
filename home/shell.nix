{ pkgs, ... }:

let
  shellAliases = {
    # Apps... but better
    git = "hub";
    v = "lvim";
    vim = "lvim";
    ls = "eza";
    cat = "bat";
    find = "fd";

    # ls
    l = "ls -l";
    ll = "ls -la";

    # misc
    e = "emacs";
    oo = "open .";
    tree = "eza --tree";
    reload = "exec fish";
    inflate = "ruby -r zlib -e \"STDOUT.write Zlib::Inflate.inflate(STDIN.read)\"";
    dark = "osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'";
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
    gui = "gitui";
  };
in
{
  home.packages = with pkgs; [
    # Packages not needing configuration
  ];

  programs.mise = {
    enable = true;

    globalConfig.tools = {
      node = "lts";
    };
  };

  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd j" ];
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$battery$username$hostname$directory$git_branch$git_status$git_state$cmd_duration$line_break$character";

      directory.read_only = " ";
      battery = {
        full_symbol = "•";
        charging_symbol = "⇡";
        discharging_symbol = "⇣";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](bright-black)( $ahead_behind$stashed)]($style) ";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
      git_state = {
        format = "([$state( $progress_current/$progress_total)]($style) )";
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
    };
  };

  programs.fish = {
    inherit shellAliases shellAbbrs;
    enable = true;

    shellInit = ''
      # Set editor
      set -x EDITOR lvim

      # Configure PNPM
      set -gx PNPM_HOME "/Users/matchai/Library/pnpm"
      set -gx PATH "$PNPM_HOME" $PATH

      # Set fish syntax highlighting
      set -g fish_color_autosuggestion '555'  'brblack'
      set -g fish_color_cancel -r
      set -g fish_color_command --bold
      set -g fish_color_comment red
      set -g fish_color_cwd green
      set -g fish_color_cwd_root red
      set -g fish_color_end brmagenta
      set -g fish_color_error brred
      set -g fish_color_escape 'bryellow'  '--bold'
      set -g fish_color_history_current --bold
      set -g fish_color_host normal
      set -g fish_color_match --background=brblue
      set -g fish_color_normal normal
      set -g fish_color_operator bryellow
      set -g fish_color_param cyan
      set -g fish_color_quote yellow
      set -g fish_color_redirection brblue
      set -g fish_color_search_match 'bryellow'  '--background=brblack'
      set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
      set -g fish_color_user brgreen
      set -g fish_color_valid_path --underline
    '';

    interactiveShellInit = ''
      # Initialize homebrew
      eval (/opt/homebrew/bin/brew shellenv)
    '';

    functions = {
      idea = "open -a \"IntelliJ IDEA.app\" $argv";
      fish_greeting = "";
    };

    plugins = [
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "master";
          sha256 = "0mb01y1d0g8ilsr5m8a71j6xmqlyhf8w4xjf00wkk8k41cz3ypky";
        };
      }
    ];
  };

  programs.zsh = {
    inherit shellAliases;
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history.extended = true;
  };
}
