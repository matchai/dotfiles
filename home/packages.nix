{
  pkgs,
  ...
}:

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
    };

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };

  xdg.configFile."mise/config.toml".source = ./mise.toml;
}
