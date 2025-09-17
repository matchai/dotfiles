{ pkgs, lib, hostname, ... }:

let
  hostPackagesFile = ./packages/hosts/${hostname}/packages.nix;
  hostPackages = if builtins.pathExists hostPackagesFile then import hostPackagesFile else [ ];

  commonNpmPackages = import ./npm-packages.nix;
  hostNpmPackagesFile = ./npm-packages/hosts/${hostname}/npm-packages.nix;
  hostNpmPackages = if builtins.pathExists hostNpmPackagesFile then import hostNpmPackagesFile else [ ];
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

    # macOS
    mas
    duti

    # Nix related
    nix-search-cli

    (pkgs.lunarvim.override {
      # Remove the vim background color, making it transparent
      globalConfig = "lvim.transparent_window = true";
    })
  ] ++ hostPackages;

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
          uv = "latest";
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
  home.file.".default-npm-packages".text = lib.strings.concatLines (commonNpmPackages ++ hostNpmPackages);
}
