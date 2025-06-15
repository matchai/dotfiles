{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      # Use 1Password's SSH agent
      "*".extraOptions = {
        identityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
      };
    };
  };
}
