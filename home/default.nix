{ ... }:

{
  imports = [
    ./shell
    ./git.nix
    ./packages.nix
    ./ssh.nix
    ./agents.nix
    ./app-defaults.nix
    ./duti.nix
    ./karabiner.nix
  ];

  home.stateVersion = "24.05";
  home.file.".hushlogin".text = "";
}
