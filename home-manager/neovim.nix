{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-polyglot
    ];
  };
}
