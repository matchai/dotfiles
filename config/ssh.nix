{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    includes = [
      # Allow for `ssh orb` to work with OrbStack
      # https://docs.orbstack.dev/machines/ssh
      "~/.orbstack/ssh/config"
    ];

    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
        extraOptions = {
          # Use 1Password's SSH agent
          # https://developer.1password.com/docs/ssh/agent/
          identityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
        };
      };
    };
  };
}
