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
    xh # fancy version of `httpie`
    yt-dlp # fancy version of `youtube-dl`
    mosh # fancy version of `ssh`
    killport
    hexyl

    # macOS
    mas
    duti

    # Workflow
    _1password-cli
    doctl

    # Languages
    php
    php83Packages.composer

    # Nix related
    nil
    nix-search-cli
    nixfmt-rfc-style

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
        deno = "latest";
        usage = "latest";
        python = "latest";
        rust = "latest";
        ruby = "latest";
        uv = "latest";
      };
    };

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };

  # Setup mise's default npm packages
  home.file.".default-npm-packages".text = lib.strings.concatLines (import ./npm-packages.nix);
}
