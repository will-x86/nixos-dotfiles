{
  config,
  pkgs,
  ...
}: {
  programs.ssh.enable = true;
  programs.ssh.extraConfig = ''
    Host github.com
      IdentityFile ~/.ssh/ed25519
  '';
}
