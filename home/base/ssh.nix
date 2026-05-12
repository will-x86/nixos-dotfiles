{
  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.settings = {
    "*" = {
      identityFile = "~/.ssh/ed25519";
      identityAgent = "~/.1password/agent.sock";
    };
    "localhost" = {
      userKnownHostsFile = "/dev/null";
    };
  };
}
