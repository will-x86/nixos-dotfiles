{
  config,
  secrets,
  pkgs,
  ...
}: {
  programs.ssh.enable = true;
  #  programs.ssh.extraConfig = ''
  #    Host github.com
  #      IdentityFile ~/.ssh/ed25519
  #    Host *
  #      IdentityFile ~/.ssh/id_ecdsa_sk
  #    Host localhost
  #        UserKnownHostsFile /dev/null
  #    Host ${secrets.b.a}
  #      IdentityFile ~/.ssh/${secrets.b.aq}
  #  '';
}
