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
    jujutsu

    # macOS
    mas
    duti

    # Workflow
    _1password-cli
    doctl

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
      globalConfig = {
        tools = {
          node = "lts";
          deno = "latest";
          usage = "latest";
          python = "latest";
          rust = "latest";
          ruby = "latest";
          uv = "latest";
        };
        settings = {
          # Required for hooks to work
          experimental = true;
          idiomatic_version_file_enable_tools = ["node"];
        };
        hooks.postinstall = "npx corepack enable";
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
