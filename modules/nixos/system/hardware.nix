{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.hardware;
in
{
  options.modules.hardware = {
    tpm = mkOption {
      type = types.bool;
      default = false;
    };
    btrfs = mkOption {
      type = types.bool;
      default = false;
    };
    earlyoom = mkOption {
      type = types.bool;
      default = false;
    };
    printing = mkOption {
      type = types.bool;
      default = false;
    };
    usbguard = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      sops = mkOption {
        type = types.bool;
        default = false;
      }; # TODO: the option doesnt exist
    };
  };
  config = mkMerge [
    (mkIf cfg.printing {
      services.printing.enable = true;
    })
    (mkIf cfg.earlyoom {
      services.earlyoom.enable = true;
      services.earlyoom.enableDebugInfo = true;
      services.earlyoom.enableNotifications = true;
      services.earlyoom.freeMemThreshold = 4;
      services.earlyoom.freeSwapThreshold = 2;
      # freeMemKillThreshold = "";
      # freeSwapKillThreshold = "";
      # reportInterval = "";
      services.earlyoom.extraArgs =
        let
          appsToAvoid = concatStringsSep "|" [
            "Gnome"
            "ghostty"
            "cryptsetup"
            "dbus-daemon"
            "dbus-broker"
            # "Xwayland"
            "gpg-agent"
          ];
          appsToPrefer = concatStringsSep "|" [
            "Web Content"
            "Isolated Web Co"
            "chromium"
            "electron"
            ".*.exe"
            "java"
            "pipewire(.*)"
          ];
        in
        [
          "-g"
          "--avoid"
          "'^(${appsToAvoid})$'"
          "--prefer"
          "'^(${appsToPrefer})$'"
        ];
      services.earlyoom.killHook = pkgs.writeShellScript "earlyoom-kill-hook" ''
        # syntax: sh
        echo "Process $EARLYOOM_NAME ($EARLYOOM_PID) was killed"
      '';

      systemd.services.earlyoom.serviceConfig = {
        DynamicUser = true;
        AmbientCapabilities = "CAP_KILL CAP_IPC_LOCK";
        Nice = -20;
        OOMScoreAdjust = -100;
        ProtectSystem = "strict";
        ProtectHome = true;
        Restart = "always";
        TasksMax = 10;
        MemoryMax = "50M";

        CapabilityBoundingSet = "CAP_KILL CAP_IPC_LOCK";
        PrivateDevices = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;

        PrivateNetwork = true;
        IPAddressDeny = "any";
        RestrictAddressFamilies = "AF_UNIX";

        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@resources @privileged"
        ];
      };
      services.systembus-notify.enable = true;
    })

    (mkIf cfg.usbguard.enable (mkMerge [
      {
        services.usbguard.enable = true;
        services.usbguard.ruleFile = config.sops.secrets."usbguard".path; # or "/var/lib/usbguard/rules.conf"
        services.usbguard.dbus.enable = true;
        services.usbguard.IPCAllowedGroups = [ "wheel" ];

        services.systembus-notify.enable = true;
        services.udev.packages = [ pkgs.usbguard-notifier ];
        systemd.user.services.usbguard-notifier.enable = true;
        systemd.packages = [ pkgs.usbguard-notifier ];
        environment.systemPackages = [ pkgs.usbguard-notifier ];

        sops.secrets."usbguard".sopsFile = ../../secrets/${cfg.info.hostname}/secrets.yaml;
        environment.persistence."/persist".directories =
          (mkIf inputs.impermanence.nixosModules.impermanence)
            [ "/var/lib/usbguard" ]; # FIXME
      }
    ]))
    (mkIf cfg.tpm {
      security.tpm2.enable = true;
      security.tpm2.pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
      security.tpm2.pkcs11.package = pkgs.tpm2-pkcs11-esapi;
      security.tpm2.tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
      security.tpm2.abrmd.enable = true;

      users.users.egor.extraGroups = [ "tss" ]; # tss group has access to TPM devices
      users.users.inti.extraGroups = [ "tss" ];
    })
    (mkIf cfg.btrfs {
      services.btrfs.autoScrub.enable = true;
      services.btrfs.autoScrub.interval = "weekly";
      services.btrfs.autoScrub.fileSystems = [ "/" ];

      services.beesd.filesystems.root.spec = "/";
      services.beesd.filesystems.root.hashTableSizeMB = 2048;
      services.beesd.filesystems.root.verbosity = "info"; # crit
      services.beesd.filesystems.root.extraOptions = [
        "--loadavg-target"
        "5.0"
      ];
      services.btrbk.instances."home" = {
        onCalendar = "hourly";
        settings.stream_compress = "lz4";
        settings.snapshot_preserve_min = "1w";
        settings.snapshot_preserve = "2w";
        settings.volume."/".snapshot_dir = "/.snapshots";
        settings.volume."/".subvolume = "home";
      };
      systemd.tmpfiles.rules = [ "d /snapshots 0755 root root" ]; # Btrbk snapshot directories

      zramSwap.enable = true;
      zramSwap.memoryPercent = 100;
      zramSwap.algorithm = "zstd";
      #boot.tmp.useZram = true;

      services.fstrim.enable = true;
      services.smartd.notifications.systembus-notify.enable = true;
      services.smartd.enable = true;
      services.smartd.devices = [ { device = "/dev/nvme0"; } ];
    })
  ];
}
