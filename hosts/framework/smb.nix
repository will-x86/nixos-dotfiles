{ secrets, pkgs, ... }:
{

  environment.etc."rclone-proton.conf".text = ''
    [remote]
    type = protondrive
    username = ${secrets.proton.email}
    password = ${secrets.proton.pass}  
  '';


  systemd.services.rclone-protondrive-mount = {
    description = "Mount Proton Drive using rclone";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple"; 

      Restart = "on-failure";
      RestartSec = "15s";

      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount \
          --config=/etc/rclone-proton.conf \
          --allow-other \
          remote:/ /mnt/protondrive
      '';

      ExecStop = "${pkgs.fuse}/bin/fusermount -u /mnt/protondrive";
    };

    wantedBy = [ "multi-user.target" ];
  };
  fileSystems."/mnt/FractalMedia" = {
    device = "//${secrets.samba.fracRemote}/Media";
    fsType = "cifs";
    options = [
      "username=will"
      "password=${secrets.samba.frac}"
      "noauto"
      "x-systemd.automount"
      "x-systemd.mount-timeout=3"
      "uid=1000"
      "gid=100"
      "dir_mode=0777"
      "file_mode=0666"
      "nofail"
    ];
  };
  fileSystems."/mnt/Fractal" = {
    device = "//${secrets.samba.fracRemote}/Vault";
    fsType = "cifs";
    options = [
      "username=will"
      "noauto"
      "password=${secrets.samba.frac}"
      "x-systemd.automount"
      "x-systemd.mount-timeout=3"
      "uid=1000"
      "gid=100"
      "dir_mode=0777"
      "file_mode=0666"
      "nofail"
    ];
  };
  fileSystems."/mnt/Immich" = {
    device = "//${secrets.samba.fracRemote}/Immich";
    fsType = "cifs";
    options = [
      "username=will"
      "noauto"
      "password=${secrets.samba.frac}"
      "x-systemd.automount"
      "x-systemd.mount-timeout=3"
      "uid=1000"
      "gid=100"
      "dir_mode=0777"
      "file_mode=0666"
      "nofail"
    ];
  };

  fileSystems."/mnt/NImmich" = {
    device = "${secrets.samba.fracRemote}:/mnt/Vault/Immich";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto" # Will mount first time accessed
      "x-systemd.idle-timeout=600" # diss after 600s
      "noatime"
      "rw"
      "soft"
      "nfsvers=4.2"
      "async"
      "nofail"
    ];
  };
  fileSystems."/mnt/NFractalMedia" = {
    device = "${secrets.samba.fracRemote}:/mnt/Vault/Media";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto" # Will mount first time accessed
      "x-systemd.idle-timeout=600" # diss after 600s
      "noatime"
      "rw"
      "soft"
      "nfsvers=4.2"
      "async"
      "nofail"
    ];
  };

  fileSystems."/mnt/NFractal" = {
    device = "${secrets.samba.fracRemote}:/mnt/Vault/Vault";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto" # Will mount first time accessed
      "x-systemd.idle-timeout=600" # diss after 600s
      "noatime"
      "rw"
      "soft"
      "nfsvers=4.2"
      "async"
      "nofail"
    ];
  };
}
