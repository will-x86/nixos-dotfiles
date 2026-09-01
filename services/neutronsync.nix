{ config, lib, pkgs, ... }:

{
  options.services.neutronsync = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable periodic Proton Drive sync (neutronsync sync) via a user timer.

        This creates the `neutronsync.service` and `neutronsync.timer` user units;
        sync runs ~5min after login and every 30min thereafter.
      '';
    };

    watch = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable live Proton Drive sync (neutronsync watch), restarting on failure.

          This creates the `neutronsync-watch.service` user unit, started at login.
          Only enable one of `enable` / `watch.enable` in practice.
        '';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.services.neutronsync.enable {
      systemd.user.services.neutronsync = {
        description = "Proton Drive bidirectional sync (neutronsync)";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        wantedBy = [ ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.neutronsync}/bin/neutronsync sync";
          Nice = 10;
          IOSchedulingClass = "idle";
        };
      };

      systemd.user.timers.neutronsync = {
        description = "Run neutronsync periodically";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "5min";
          OnUnitActiveSec = "30min";
          Persistent = true;
        };
      };
    })

    (lib.mkIf config.services.neutronsync.watch.enable {
      systemd.user.services.neutronsync-watch = {
        description = "Proton Drive live sync (neutronsync watch)";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.neutronsync}/bin/neutronsync watch";
          Restart = "on-failure";
          RestartSec = 30;
          Nice = 10;
          IOSchedulingClass = "idle";
        };
      };
    })
  ];
}