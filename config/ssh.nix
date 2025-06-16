{
  programs.ssh = {
    enable = true;

    includes = [
      # Allow for `ssh orb` to work with OrbStack
      # https://docs.orbstack.dev/machines/ssh
      "~/.orbstack/ssh/config"
    ];

    matchBlocks = {
      "*".extraOptions = {
        # Use 1Password's SSH agent
        # https://developer.1password.com/docs/ssh/agent/
        identityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
      };
    };
  };
}
