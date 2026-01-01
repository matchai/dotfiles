{ inputs, ... }:

{
  imports = [
    ./shell
    ./git.nix
    ./packages.nix
    ./ssh.nix
    ./claude.nix
    ./iterm2.nix
    ./karabiner.nix
    inputs.try.homeModules.default
  ];

  home.stateVersion = "24.05";
  home.file.".hushlogin".text = "";
}
