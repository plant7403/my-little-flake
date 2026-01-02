{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.system;
in
{
  options.modules.system = {
    printing = mkOption {
      type = types.bool;
      default = false;
    };
    ssh = mkOption {
      type = types.bool;
      default = false;
    };
    hostname = mkOption {
      type = types.str;
      #default = "default";
    };
    cleanup = mkOption {
      type = types.bool;
      default = false;
    };
    autoupdate = mkOption {
      type = types.bool;
      default = false;
    };
    hardening = mkOption {
      type = types.bool;
      default = false;
    };
    av = mkOption {
      type = types.bool;
      default = false;
    };
    distributed = mkOption {
      type = types.bool;
      default = false;
    };
    usbguard.enable = mkOption {
      type = types.bool;
      default = false;
    };
    usbguard.sops = mkOption {
      type = types.bool;
      default = false;
    };
    earlyoom = mkOption {
      type = types.bool;
      default = false;
    };
    tpm = mkOption {
      type = types.bool;
      default = false;
    };
    btrfs = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    {
      networking.hostName = cfg.hostname;
      time.timeZone = "Europe/Madrid";
      i18n.defaultLocale = "es_ES.UTF-8";

      environment.systemPackages = with pkgs; [
        wget
        git
        nano
        openssl
      ];

      environment.pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];

      programs.adb.enable = true;

      boot.plymouth.enable = true;
      boot.plymouth.tpm2-totp.enable = true;
      #services.devmon.enable = true;
      services.tuned.enable = true;
      services.fwupd.enable = true;
      boot.crashDump.enable = true;

      hardware.bluetooth.enable = true; # enables support for Bluetooth
      hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boots
      hardware.bluetooth.settings.General."Experimental" = true;

      # Enable networking
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;
      services.stubby.enable = true;
      services.stubby.settings = pkgs.stubby.passthru.settingsExample // {
        upstream_recursive_servers = [
          {
            address_data = "9.9.9.11";
            tls_auth_name = "tls://dns11.quad9.net";
            tls_pubkey_pinset = [
              {
                digest = "sha256";
                value = "i2kObfz0qIKCGNWt7MjBUeSrh0Dyjb0/zWINImZES+I=";
              }
            ];
          }
          {
            address_data = "149.112.112.11";
            tls_auth_name = "tls://dns11.quad9.net";
            tls_pubkey_pinset = [
              {
                digest = "sha256";
                value = "i2kObfz0qIKCGNWt7MjBUeSrh0Dyjb0/zWINImZES+I=";
              }
            ];
          }
        ];
        # 9.9.9.11
        # 149.112.112.11
      };
    }
    (mkIf cfg.shell {
      users.defaultUserShell = pkgs.zsh;
      programs.zoxide.enableZshIntegration = true;
      environment.shells = with pkgs; [ zsh ];
      environment.pathsToLink = [
        "/share/zsh"
      ];
    })
    (mkIf cfg.docs {
      environment.systemPackages = with pkgs; [
        man-pages
        man-pages-posix
        cheat
        cht-sh
        navi
      ];
      documentation.nixos.enable = true;
      documentation.man.enable = true;
      documentation.man.man-db.enable = false;
      documentation.man.mandoc.enable = true;
      documentation.man.generateCaches = true;
    })
    (mkIf cfg.vm-test {
      users.users.nixosvmtest.isSystemUser = true;
      users.users.nixosvmtest.initialPassword = "hellohowareyou?";
      users.groups.nixosvmtest = { };
      users.users.nixosvmtest.group = "nixosvmtest";
      virtualisation.vmVariant.virtualisation.memorySize = 2048;
      virtualisation.vmVariant.virtualisation.cores = 3;
    })
    (mkIf cfg.emergency {
      boot.initrd.systemd.emergencyAccess = "$y$j9T$LSLJIAlFbp6k3cetejjE60$vcn.wkp7k/hmYG525hhkID5qCM8DXBQWsoqky.2kQ.4";
      boot.initrd.systemd.initrdBin = [ ];
      systemd.enableEmergencyMode = true; # !!! TODO !!! TO REMOVE !!!
    })
    (mkIf cfg.printing {
      services.printing.enable = true;
    })
    (mkIf cfg.ssh {
      services.openssh = {
        enable = true;
        ports = [ 3370 ];
        openFirewall = true;
        settings.PasswordAuthentication = false;
        settings.challengeResponseAuthentication = false;
        extraConfig = ''
          AllowTcpForwarding yes
          X11Forwarding yes
          AllowAgentForwarding yes
          AllowStreamLocalForwarding yes
          AuthenticationMethods publickey
          X11UseLocalhost no
          StreamLocalBindUnlink yes
        '';
      };
    })
    (mkIf cfg.cleanup {
      nix = mkIf (config.programs.nh.clean.enable != true) {
        gc.automatic = true;
        gc.dates = "Monday 01:00 UTC";
        gc.options = "--delete-older-than 2d";
        extraOptions = ''
          min-free = ${toString (5000 * 1024 * 1024)}
        '';
      };
      systemd.services.clear-log = {
        description = "Clear >1 month-old logs every week";
        serviceConfig.Type = "oneshot";
        serviceConfig.ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=30d";
      };
      systemd.timers.clear-log = {
        wantedBy = [ "timers.target" ];
        partOf = [ "clear-log.service" ];
        timerConfig.OnCalendar = "weekly UTC";
      };
    })
    (mkIf cfg.autoupdate {
      system.autoUpgrade = {
        enable = true;
        flake = "path:${rootPath}";
        flags = [
          "--update-input"
          "nixpkgs"
          "-L"
        ];
        dates = "09:00";
        randomizedDelaySec = "45min";
        persistent = true;
      };
    })
    (mkIf cfg.hardening {
      # boot.kernelPackages = pkgs.linuxPackages_hardened;
      boot.kernelModules = [ "tcp_bbr" ];
      boot.kernel.sysctl = {
        "kernel.sysrq" = 1;
        "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.secure_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 0;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.all.accept_source_route" = 0;
        "net.ipv4.tcp_rfc1337" = 1;
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
      };
    })
    (mkIf cfg.av {
      environment.systemPackages = [ pkgs.clamav ];
      services.clamav.daemon.enable = true;
      services.clamav.updater.enable = true;
    })
    (mkIf cfg.distributed {
      nix.distributedBuilds = true;
      nix.settings.builders-use-substitutes = true;
      nix.buildMachines = [
        {
          hostName = "horizon";
          system = "x86_64-linux";
          protocol = "ssh-ng";
          maxJobs = 0;
          speedFactor = 0;
          supportedFeatures = [
            "nixos-test"
            "benchmark"
            "big-parallel"
            "kvm"
          ];
          mandatoryFeatures = [ ];
        }
      ];
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

        sops.secrets."usbguard".sopsFile = ../../secrets/${cfg.hostname}/secrets.yaml;
        environment.persistence."/persist".directories = (mkIf config.CHANGEME) [ "/var/lib/usbguard" ]; # FIXME
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
