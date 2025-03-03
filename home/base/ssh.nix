{
  config,
  secrets,
  pkgs,
  ...
}: {
  programs.ssh.enable = true;
  programs.ssh.extraConfig = ''
    Host *
      IdentityFile ~/.ssh/ed25519
    Host ${secrets.b.a}
      IdentityFile ~/.ssh/${secrets.b.aq}
  '';
}
