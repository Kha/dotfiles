{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  home.packages = with pkgs; [
    networkmanager_dmenu
    pdfpc
    linuxPackages.perf
  ];

  systemd.user.services.backup = {
    Unit.Description = "backup to rsync.net";
    Service = {
      Environment = ''PATH=${ pkgs.lib.makeBinPath [ pkgs.openssh ] }'';
      ExecStart = ''${pkgs.rsync}/bin/rsync -avxH --exclude=/.cache/ --exclude=/.ccache/ --exclude=/.local/ --exclude=/Downloads/ --exclude=build/ --delete-before --delete-excluded /home/sebastian/ rsync:sebastian'';
    };
  };

  systemd.user.timers.backup = {
    Unit = {
      Description = "timer for rsync.net backup";
      PartOf      = [ "backup.service" ];
    };
    Install = {
      WantedBy    = [ "timers.target" ];
    };
    Timer = {
      OnCalendar = "13:00";
      Persistent = true;
    };
  };
}
