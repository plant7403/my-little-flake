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
    usbguard.enable = mkOption {
      type = types.bool;
      default = false;
    };
    usbguard.sops = mkOption {
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
nix = {

        settings.experimental-features = [
          "flakes"
          "nix-command"
        ];
        settings = {
          always-allow-substitutes = true;
          substituters = [
            #"https://cachix.cachix.org"
            #"https://devenv.cachix.org"
            "https://cache.nixos.org/"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            #"cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
            #"devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
        };

        settings.trusted-users = [
          "root"
          "egor"
          "inti"
        ];
        package = pkgs.lixPackageSets.stable.lix;


      # Nix package manager optimizations

        settings = {
          # Optimize store to remove duplicate files
          auto-optimise-store = true;

          # Allow building multiple derivations in parallel
          max-jobs = "auto";

          # Number of parallel build tasks per job
          cores = 0; # 0 means use all available cores

          # Use the binary cache aggressively
          substituters = [
            "<https://cache.nixos.org>"
            "<https://nix-community.cachix.org>"
            "<https://nixpkgs-wayland.cachix.org>"
          ];

          # Optimize fetching from GitHub
          connect-timeout = 5;

          # Prevent unneeded rebuilds
          commit-lockfile-summary = "Update flake.lock";
        };

        # Garbage collection settings
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };

        # Optimize builds using different build cores
        buildCores = 0; # 0 means use all available cores

        # Enable flakes and modern Nix command features
        extraOptions = ''
          experimental-features = nix-command flakes
          warn-dirty = false
          keep-going = true
          log-lines = 20
        '';

};

      nixpkgs.overlays = [
        (final: prev: {
          inherit (prev.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })
      ];

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "vscode-extension-github-copilot"
          "vscode-extension-github-copilot-chat"
          "obsidian"
        ];
      /*
        programs.nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
          flake = "/home/user/my-nixos-config"; # sets NH_OS_FLAKE variable for you
        };
      */
      #nix.settings.download-buffer-size = 524288000;

      networking.hostName = cfg.hostname; # Define your hostname.
      boot.plymouth.enable = true;

      # Set your time zone.
      time.timeZone = "Europe/Madrid";

      # Select internationalisation properties.
      i18n.defaultLocale = "es_ES.UTF-8";
      /*
           i18n.extraLocales = [
          "en_US.UTF-8"
        ];
      */
      /*
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
      */
      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        wget
        git
        nano

        man-pages
        man-pages-posix
        cheat
        cht-sh
        navi
        openssl
        nixd

        nixos-rebuild-ng

      ];

      documentation = {
        nixos.enable = true;
        man = {
          # In order to enable to mandoc man-db has to be disabled.
          enable = true;
          man-db.enable = false;
          mandoc.enable = true;
          generateCaches = true;

        };
      };

      users.defaultUserShell = pkgs.zsh;
      environment.shells = with pkgs; [ zsh ];
      programs.zoxide.enableZshIntegration = true;
      programs.direnv.enableZshIntegration = true;
      /*
        environment.persistence."/persist".directories = [
          "/var/cache/man"
        ];
      */
      # probably not needed, the config has diffferent paths and the dir is empty

      programs.adb.enable = true;
      services.fwupd.enable = true;

      hardware.bluetooth.enable = true; # enables support for Bluetooth
      hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boots
      hardware.bluetooth.settings = {
        General = {
          Experimental = true;
        };
      };
      # Enable networking
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;
      #9.9.9.11
      #149.112.112.11

      services.stubby = {
        enable = true;
        settings = pkgs.stubby.passthru.settingsExample // {
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
        };
      };
      # services.fstrim.interval
      services.fstrim.enable = true;

      users.users.nixosvmtest.isSystemUser = true;
      users.users.nixosvmtest.initialPassword = "test";

      users.groups.nixosvmtest = { };
      users.users.nixosvmtest.group = "nixosvmtest";

      virtualisation.vmVariant = {
        # the following configuration is added only when building VM with `build-vm`
        virtualisation = {
          memorySize = 2048; # use 2048MiB memory
          cores = 3; # use 3 cpu cores
        };
      };
      boot.initrd.systemd.emergencyAccess = "$y$j9T$LSLJIAlFbp6k3cetejjE60$vcn.wkp7k/hmYG525hhkID5qCM8DXBQWsoqky.2kQ.4";

      boot.initrd.systemd.initrdBin = [

      ];

      systemd.enableEmergencyMode = true; # !!! TODO !!! TO REMOVE !!!

      specialisation = {
        nogui.configuration = {
          services.xserver.desktopManager.gnome.enable = lib.mkForce false;
        };
        gui = {
          #inheritParentConfig = false;
          configuration = {
            system.nixos.tags = [ "ooo" ];
            #services.xserver.desktopManager.gnome.enable = true;
            users.users.ooo = {
              isNormalUser = true;
              uid = 1002;
              extraGroups = [
                "networkmanager"
                "video"
              ];
            };
            services.xserver.displayManager.autoLogin = {
              enable = true;
              user = "ooo";
            };
            environment.systemPackages = with pkgs; [
              dune-release
            ];
          };
        };
      };
    }
    (mkIf cfg.printing {
      # Enable CUPS to print documents.
      services.printing.enable = true;
    })
    (mkIf cfg.ssh {
      services.openssh = {
        enable = true;
        ports = [ 3370 ];
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
          wantedBy = [ "timers.target" ];
          partOf = [ "clear-log.service" ];
          timerConfig.OnCalendar = "weekly UTC";
        };
      };
    })
    (mkIf cfg.autoupdate {
      system.autoUpgrade = {
        enable = true;
        #flake = "path:${rootPath}";
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
      boot.kernelModules = [ "tcp_bbr" ];

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
    (mkIf cfg.usbguard.enable (mkMerge [
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
        systemd.packages = with pkgs; [ usbguard-notifier ];
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
      (mkIf cfg.tpm {
        security.tpm2.enable = true;
        security.tpm2.pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
        security.tpm2.tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
        users.users.egor.extraGroups = [ "tss" ]; # tss group has access to TPM devices
        users.users.inti.extraGroups = [ "tss" ];
      })
    ]))
    (mkIf cfg.btrfs {
      services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = [ "/" ];
      };
      services.beesd.filesystems = {
        root = {
          spec = "/";
          hashTableSizeMB = 2048;
          verbosity = "info"; # crit
          extraOptions = [
            "--loadavg-target"
            "5.0"
          ];
        };
        /*
          home = {
            spec = "LABEL=@HOME";
            hashTableSizeMB = 2048;
            verbosity = "crit";
            extraOptions = [
              "--loadavg-target"
              "5.0"
            ];
          };
        */
      };
      services.btrbk = {
        instances."home" = {
          onCalendar = "hourly";
          settings = {
            stream_compress = "lz4";
            snapshot_preserve_min = "1w";
            snapshot_preserve = "2w";
            volume = {
              "/" = {
                snapshot_dir = "/.snapshots";
                subvolume = "home";
              };
            };
          };
        };
      };
      # Btrbk does not create snapshot directories automatically, so create one here.
      systemd.tmpfiles.rules = [
        "d /snapshots 0755 root root"
      ];
    })

  ];
  #path = config.sops.secrets."system/hostkeys/luna/ed25519".path;
  #sops.secrets."system/hostkeys/luna/rsa" = {};
}
