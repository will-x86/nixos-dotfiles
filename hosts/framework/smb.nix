{ secrets, ... }:
{
  fileSystems."/mnt/Immich" = {
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
  fileSystems."/mnt/FractalMedia" = {
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

  fileSystems."/mnt/FractalVault" = {
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
