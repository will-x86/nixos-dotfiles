{
  config,
  secrets,
  pkgs,
  ...
}: {
  programs.ssh.enable = true;
  
    #Host *
    #  IdentityFile ~/.ssh/id_ecdsa_sk
  programs.ssh.extraConfig = ''
    Host *
      IdentityFile ~/.ssh/ed25519
    Host localhost
        UserKnownHostsFile /dev/null
    Host ${secrets.b.a}
      IdentityFile ~/.ssh/${secrets.b.aq}
  '';
}
