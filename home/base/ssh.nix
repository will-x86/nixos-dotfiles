{
  config,
  pkgs,
  ...
}: {
  programs.ssh.enable = true;
  programs.ssh.extraConfig = ''
    Host *
      IdentityFile ~/.ssh/ed25519
  '';
}
