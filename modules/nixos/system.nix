{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.system;
in {
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
    usbguard.enable = mkOption {
      type = types.bool;
      default = false;
    };
    usbguard.sops = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    {
      nix.settings.experimental-features = ["flakes" "nix-command"];
      nix.settings = {
        extra-substituters = [
          "https://cachix.cachix.org"
          "https://devenv.cachix.org"
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
          "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      networking.hostName = cfg.hostname; # Define your hostname.

      # Set your time zone.
      time.timeZone = "Asia/Ho_Chi_Minh";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        wget
        git
        nano
      ];
      programs.adb.enable = true;
      services.fwupd.enable = true;

      # Enable networking
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;
    }
    (mkIf cfg.printing {
      # Enable CUPS to print documents.
      services.printing.enable = true;
    })
    (mkIf cfg.ssh {
      services.openssh = {
        enable = true;
        ports = [3370];
        openFirewall = true;
        settings = {
          PasswordAuthentication = false;
          #allowSFTP = false; # Don't set this if you need sftp
          challengeResponseAuthentication = false;
        };
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
      ## Garbage collection
      # https://nixos.wiki/wiki/Storage_optimization#Automation
      nix.gc = {
        automatic = true;
        dates = "Monday 01:00 UTC";
        options = "--delete-older-than 2d";
      };

      # Run garbage collection whenever there is less than 500MB free space left
      nix.extraOptions = ''
        min-free = ${toString (5000 * 1024 * 1024)}
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
          wantedBy = ["timers.target"];
          partOf = ["clear-log.service"];
          timerConfig.OnCalendar = "weekly UTC";
        };
      };
    })
    (mkIf cfg.autoupdate {
      system.autoUpgrade = {
        enable = true;
        flake = inputs.self.outPath;
        flags = [
          "--update-input"
          "nixpkgs"
          "-L" # print build logs
        ];
        dates = "09:00";
        randomizedDelaySec = "45min";
        persistent = true;
      };
    })
    (mkIf cfg.hardening {
      ## Hardened kernel
      #  boot.kernelPackages = pkgs.linuxPackages_hardened;

      ## Enable BBR
      boot.kernelModules = ["tcp_bbr"];

      ## Network hardening and performance
      boot.kernel.sysctl = {
        # Disable magic SysRq key
        "kernel.sysrq" = 0;
        # Ignore ICMP broadcasts to avoid participating in Smurf attacks
        "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
        # Ignore bad ICMP errors
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
        # Reverse-path filter for spoof protection
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        # SYN flood protection
        "net.ipv4.tcp_syncookies" = 1;
        # Do not accept ICMP redirects (prevent MITM attacks)
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.secure_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 0;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
        # Do not send ICMP redirects (we are not a router)
        "net.ipv4.conf.all.send_redirects" = 0;
        # Do not accept IP source route packets (we are not a router)
        "net.ipv4.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.all.accept_source_route" = 0;
        # Protect against tcp time-wait assassination hazards
        "net.ipv4.tcp_rfc1337" = 1;
        # Latency reduction
        "net.ipv4.tcp_fastopen" = 3;
        ## Bufferfloat mitigations
        # Requires >= 4.9 & kernel module
        "net.ipv4.tcp_congestion_control" = "bbr";
        # Requires >= 4.19
        "net.core.default_qdisc" = "cake";
      };
    })
    (
      mkIf cfg.usbguard.enable
      (mkMerge [
        {
          ## USBGuard
          # Load "/var/lib/usbguard/rules.conf" by default
          services.usbguard.enable = true;
          services.usbguard.dbus.enable = true;
          #services.usbguard.IPCAllowedGroups = ["wheel"];
          services.udev.packages = [
            pkgs.usbguard-notifier
          ];
          systemd.user.services.usbguard-notifier.enable = true;
          systemd.packages = with pkgs; [usbguard-notifier];
          services.systembus-notify.enable = true;
          environment.systemPackages = with pkgs; [
            usbguard-notifier
          ];

          environment.persistence."/persist".directories = [
            "/var/lib/usbguard"
          ];
        }
        (mkIf cfg.usbguard.sops {
          services.usbguard.ruleFile = config.sops.secrets."usbguard".path;
          sops.secrets."usbguard" = {
            sopsFile = ../../secrets/${cfg.hostname}/secrets.yaml;
          };
        })
      ])
    )
  ];
  #path = config.sops.secrets."system/hostkeys/luna/ed25519".path;
  #sops.secrets."system/hostkeys/luna/rsa" = {};
}
