{ pkgs, lib, npmPackages ? [], ... }:

let
  commonNpmPackages = import ./npm-packages.nix;
in
{
  home.packages = with pkgs; [
    # CLIs but better
    bat # fancy version of `cat`
    fd # fancy version of `find`
    eza # fancy version of `ls`
    ripgrep # fancy version of `grep`
    procs # fancy version of `ps`
    bottom # fancy version of `top`
    xh # fancy version of `httpie`
    yt-dlp # fancy version of `youtube-dl`
    mosh # fancy version of `ssh`

    # Productivity
    ffmpeg

    # Development
    ast-grep
    biome
    hexyl
    hyperfine
    graphite-cli
    jujutsu
    killport

    # Git
    diff-so-fancy
    gitui
    tig
    gh
    lazygit

    # macOS
    mas
    duti

    # Nix related
    nix-search-cli

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
          bun = "latest";
          node = "lts";
          deno = "latest";
          usage = "latest";
          python = "latest";
          rust = "latest";
          uv = "latest";
          go = "latest";
        };
        settings = {
          # Required for hooks to work
          experimental = true;
          idiomatic_version_file_enable_tools = [ "node" ];
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
  home.file.".default-npm-packages".text = lib.concatLines (commonNpmPackages ++ npmPackages);
}
