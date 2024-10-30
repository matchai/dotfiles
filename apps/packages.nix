{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # CLIs
    bat # fancy version of `cat`
    fd # fancy version of `find`
    eza # fancy version of `ls`
    ripgrep # fancy version of `grep`
    procs # fancy version of `ps`
    bottom # fancy version of `top`

    # Blocked by https://nixpk.gs/pr-tracker.html?pr=350035
    # mosh # fancy version of `ssh`

    # macOS
    mas
    duti

    # Workflow
    _1password # The CLI for 1Password
    doctl

    # Nix related
    nil
    nixfmt

    (pkgs.lunarvim.override {
      # Remove the vim background color, making it transparent
      globalConfig = "lvim.transparent_window = true";
    })
  ];

  programs = {
    mise = {
      enable = true;
      globalConfig.tools = {
        node = "lts";
        usage = "latest";
      };
    };

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };

  # Setup mise's default npm packages
  home.file.".default-npm-packages".text =
    lib.strings.concatLines (import ./npm-packages.nix);
}
