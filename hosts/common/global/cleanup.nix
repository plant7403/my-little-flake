# TODO - Check if it's even working

{ pkgs, ... }: {
  ## Unattended upgrade
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "weekly UTC";
  };

  ## Garbage collection
  # https://nixos.wiki/wiki/Storage_optimization#Automation
  nix.gc = {
    automatic = true;
    dates = "Monday 01:00 UTC";
    options = "--delete-older-than 7d";
  };

  # Run garbage collection whenever there is less than 500MB free space left
  nix.extraOptions = ''
    min-free = ${toString (500 * 1024 * 1024)}
  '';

  ## Optional: Clear >1 month-old logs
  systemd = {
    services.clear-log = {
      description = "Clear >1 month-old logs every week";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=30d";
      };
    };
    timers.clear-log = {
      wantedBy = [ "timers.target" ];
      partOf = [ "clear-log.service" ];
      timerConfig.OnCalendar = "weekly UTC";
    };
  };
}
