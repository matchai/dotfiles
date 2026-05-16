{
  pkgs,
  lib,
  npmPackages ? [ ],
  ...
}:

let
  commonNpmPackages = import ./npm-packages.nix;
in
{
  home.packages = with pkgs; [
    # CLIs but better
    bat # cat replacement
    fd # find replacement
    eza # ls replacement
    ripgrep # grep replacement
    procs # ps replacement
    bottom # top replacement
    xh # httpie replacement
    yt-dlp # youtube-dl replacement
    mosh # ssh replacement

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
    nil
    nix-search-cli
  ];

  programs = {
    mise = {
      enable = true;
      enableFishIntegration = false; # cached in shell/default.nix
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
