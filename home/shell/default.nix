{ user, ... }:

let
  aliases = {
    # Apps... but better
    v = "lvim";
    vim = "lvim";
    ls = "eza";
    cat = "bat";
    tree = "eza --tree";

    # ls
    l = "ls -l";
    ll = "ls -la";

    # misc
    oo = "open .";
    reload = "exec fish";
    inflate = ''ruby -r zlib -e "STDOUT.write Zlib::Inflate.inflate(STDIN.read)"'';
    dark = "osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'";
    wtc = "wt switch --create";
    wsc = "wt switch --create --execute \"opencode run\"";
  };

  gitAbbrs = {
    lg = "lazygit";
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
    gsu = "git branch --set-upstream-to=origin/(git rev-parse --abbrev-ref HEAD)";
  };
in
{
  imports = [ ./starship.nix ];

  # Merge abbreviations with aliases for non-fish shells
  home.shellAliases = aliases // gitAbbrs;

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd j" ];
  };

  programs.fish = {
    enable = true;
    shellAbbrs = gitAbbrs;

    shellInit = ''
      # Set editor
      set -gx EDITOR lvim

      # Set a PNPM home shared across versions
      set -gx PNPM_HOME "/Users/${user}/Library/pnpm"

      # Initialize homebrew - cached env vars (faster than eval)
      set -gx HOMEBREW_PREFIX "/opt/homebrew"
      set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
      set -gx HOMEBREW_REPOSITORY "/opt/homebrew"
      fish_add_path -gP /opt/homebrew/bin /opt/homebrew/sbin

      # Add PNPM to PATH
      fish_add_path $PNPM_HOME
    '';

    interactiveShellInit = ''
      # Set fish syntax highlighting
      set -g fish_color_autosuggestion '555' 'brblack'
      set -g fish_color_cancel -r
      set -g fish_color_command --bold
      set -g fish_color_comment red
      set -g fish_color_cwd green
      set -g fish_color_cwd_root red
      set -g fish_color_end brmagenta
      set -g fish_color_error brred
      set -g fish_color_escape 'bryellow' '--bold'
      set -g fish_color_history_current --bold
      set -g fish_color_host normal
      set -g fish_color_match --background=brblue
      set -g fish_color_normal normal
      set -g fish_color_operator bryellow
      set -g fish_color_param cyan
      set -g fish_color_quote yellow
      set -g fish_color_redirection brblue
      set -g fish_color_search_match 'bryellow' '--background=brblack'
      set -g fish_color_selection 'white' '--bold' '--background=brblack'
      set -g fish_color_user brgreen
      set -g fish_color_valid_path --underline
    '';

    functions = {
      tableplus = "open -a TablePlus $argv";
      idea = ''open -a "IntelliJ IDEA.app" $argv'';  # needs '' for embedded quotes
      code = "if test (count $argv) -eq 0; command cursor (git rev-parse --show-toplevel 2>/dev/null || pwd); else; command cursor $argv[1]; end";
      fish_greeting = "";

      # Nix helpers
      nix-switch = "darwin-rebuild switch --flake ~/.config/nixpkgs";
      nix-update = "nix flake update --flake ~/.config/nixpkgs";
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history.extended = true;
  };
}
