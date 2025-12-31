
















































                  digest = "sha256";
                  digest = "sha256";
                  value = "i2kObfz0qIKCGNWt7MjBUeSrh0Dyjb0/zWINImZES+I=";
                  value = "i2kObfz0qIKCGNWt7MjBUeSrh0Dyjb0/zWINImZES+I=";
                 automatic = true;
                 dates = "weekly";
                 options = "--delete-older-than 30d";
                "networkmanager"
                "video"
                {
                {
                }
                }
                snapshot_dir = "/.snapshots";
                subvolume = "home";
               };
              "--loadavg-target"
              "/" = {
              "5.0"
              ];
              ];
              ];
              };
              address_data = "149.112.112.11";
              address_data = "9.9.9.11";
              dune-release
              enable = true;
              extraGroups = [
              isNormalUser = true;
              tls_auth_name = "tls://dns11.quad9.net";
              tls_auth_name = "tls://dns11.quad9.net";
              tls_pubkey_pinset = [
              tls_pubkey_pinset = [
              uid = 1002;
              user = "ooo";
            ;
            "--loadavg-target"
            "5.0"
            "benchmark"
            "big-parallel"
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "egor"
            "flakes"
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "inti"
            "kvm"
            "nix-command"
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "nixos-test"
            "root"
            ];
            ];
            {
            {
            }
            }
            };
            };
            };
            #"cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
            #"devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
            #services.xserver.desktopManager.gnome.enable = true;
            colmena
            device = "/dev/disk/by-id/ata-WDC-XXXXXX-XXXXXX"; # FIXME: Change this to your actual disk
            environment.systemPackages = with pkgs; [
            ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=30d";
            extraOptions = [
            hashTableSizeMB = 2048;
            nix-eval-jobs
            nix-fast-build
            nixpkgs-review
            services.xserver.displayManager.autoLogin = {
            snapshot_preserve = "2w";
            snapshot_preserve_min = "1w";
            spec = "LABEL=@HOME";
            stream_compress = "lz4";
            system.nixos.tags = [ "ooo" ];
            Type = "oneshot";
            users.users.ooo = {
            verbosity = "crit";
            volume = {
           i18n.extraLocales = [
           i18n.extraLocaleSettings = {
          "--update-input"
          "-L" # print build logs
          "/var/cache/man"
          "/var/lib/usbguard"
          "en_US.UTF-8"
          "nixpkgs"
          "obsidian"
          "vscode-extension-github-copilot-chat"
          "vscode-extension-github-copilot"
          ];
          ];
          ];
          ];
          ];
          ];
          ];
          {
          }
          };
          };
          };
          };
          # - M1, M2, M3 ARM Macs use   "aarch64-darwin"
          # - Newer RISCV computers use "riscv64-linux"
          # - Normal Intel/AMD CPUs use "x86_64-linux"
          # - Raspberry Pi 4 and 5 use  "aarch64-linux"
          # (e.g. search for "binfmt" for emulation),
          # Allow building multiple derivations in parallel
          # are taken from your "~/.ssh/config" file.
          # CPU architecture of the builder, and the operating system it runs.
          # default is 1 but may keep the builder idle in between builds
          # how fast is the builder compared to your local machine
          # If your builder supports multiple architectures
          # In order to enable to mandoc man-db has to be disabled.
          # Nix custom ssh-variant that avoids lots of "trusted-users" settings pain
          # Nix package manager optimizations
          # Number of parallel build tasks per job
          # Optimize fetching from GitHub
          # Optimize store to remove duplicate files
          # Prevent unneeded rebuilds
          # Replace the line by the architecture of your builder, e.g.
          # See https://github.com/NixOS/nixpkgs/blob/nixos-unstable/lib/systems/flake-systems.nix
          # systems = ["x86_64-linux" "aarch64-linux" "riscv64-linux"];
          # The details of the connection (user, port, url etc.)
          # Use the binary cache aggressively
          # Will be used to call "ssh builder" to connect to the builder machine.
          # you can list them all, e.g. replace with
          #!include ${config.sops.secrets."system/nix-token".path}
          #allowSFTP = false; # Don't set this if you need sftp
          #inheritParentConfig = false;
          AllowAgentForwarding yes
          AllowStreamLocalForwarding yes
          AllowTcpForwarding yes
          always-allow-substitutes = true;
          AuthenticationMethods publickey
          auto-optimise-store = true;
          challengeResponseAuthentication = false;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
          commit-lockfile-summary = "Update flake.lock";
          configuration = {
          connect-timeout = 5;
          cores = 0; # 0 means use all available cores
          cores = 3; # use 3 cpu cores
          description = "Clear >1 month-old logs every week";
          enable = true;
          enable = true;
          Experimental = true;
          experimental-features = [
          experimental-features = nix-command flakes
          extraOptions = [
          flake = "/home/user/my-nixos-config"; # sets NH_OS_FLAKE variable for you
          gc = {
          generateCaches = true;
          hashTableSizeMB = 2048;
          home = {
          hostName = "horizon";
          inherit (prev.lixPackageSets.stable)
          keep-going = true
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
          log-lines = 20
          man-db.enable = false;
          mandatoryFeatures = [ ];
          mandoc.enable = true;
          max-jobs = "auto";
          maxJobs = 0;
          memorySize = 2048; # use 2048MiB memory
          onCalendar = "hourly";
          partOf = [ "clear-log.service" ];
          PasswordAuthentication = false;
          pkgs.usbguard-notifier
          protocol = "ssh-ng";
          serviceConfig = {
          services.xserver.desktopManager.gnome.enable = lib.mkForce false;
          settings = {
          sopsFile = ../../secrets/${cfg.hostname}/secrets.yaml;
          spec = "/";
          speedFactor = 0;
          StreamLocalBindUnlink yes
          substituters = [
          supportedFeatures = [
          system = "x86_64-linux";
          timerConfig.OnCalendar = "weekly UTC";
          trusted-public-keys = [
          trusted-users = [
          upstream_recursive_servers = [
          usbguard-notifier
          verbosity = "info"; # crit
          wantedBy = [ "timers.target" ];
          warn-dirty = false
          X11Forwarding yes
          X11UseLocalhost no
        '';
        '';
        "d /snapshots 0755 root root"
        "kernel.sysrq" = 0;
        "net.core.default_qdisc" = "cake";
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.all.accept_source_route" = 0;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.all.secure_redirects" = 0;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.default.secure_redirects" = 0;
        "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_rfc1337" = 1;
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
        (final: prev: {
        ];
        ];
        ];
        ];
        ];
        ];
        ];
        ];
        {
        }
        };
        };
        };
        };
        };
        };
        };
        };
        };
        };
        };
        };
        };
        };
        };
        })
        */
        */
        /*
        /*
        # Disable magic SysRq key
        # Do not accept ICMP redirects (prevent MITM attacks)
        # Do not accept IP source route packets (we are not a router)
        # Do not send ICMP redirects (we are not a router)
        # Enable flakes and modern Nix command features
        # Garbage collection settings
        # Ignore bad ICMP errors
        # Ignore ICMP broadcasts to avoid participating in Smurf attacks
        # Latency reduction
        # Load "/var/lib/usbguard/rules.conf" by default
        # Optimize builds using different build cores
        # Protect against tcp time-wait assassination hazards
        # Requires >= 4.19
        # Requires >= 4.9 & kernel module
        # Reverse-path filter for spoof protection
        # SYN flood protection
        # the following configuration is added only when building VM with `build-vm`
        ## Bufferfloat mitigations
        ## USBGuard
        #flake = "path:${rootPath}";
        #services.usbguard.IPCAllowedGroups = ["wheel"];
        automatic = true;
        buildCores = 0; # 0 means use all available cores
        builders-use-substitutes = true;
        builtins.elem (lib.getName pkg) [
        cheat
        cht-sh
        dates = "09:00";
        dates = "Monday 01:00 UTC";
        devices = [
        enable = true;
        enable = true;
        enable = true;
        enable = true;
        enable = true;
        enable = true;
        enableDebugInfo = true;
        enableNotifications = true;
        environment.persistence."/persist".directories = [
        environment.persistence."/persist".directories = [
        environment.systemPackages = with pkgs; [
        extraArgs = [ ];
        extraConfig = ''
        extraOptions = ''
        fileSystems = [ "/" ];
        flags = [
        freeMemKillThreshold = "";
        freeMemThreshold = "";
        freeSwapKillThreshold = "";
        freeSwapThreshold = "";
        General = {
        git
        group = config.users.groups.keys.name;
        gui = {
        instances."home" = {
        interval = "weekly";
        killHook = '''';
        man = {
        man-pages
        man-pages-posix
        min-free = ${toString (5000 * 1024 * 1024)}
        mode = "0440";
        nano
        navi
        nixd
        nixos-rebuild-ng
        nixos.enable = true;
        nogui.configuration = {
        notifications.systembus-notify.enable = true;
        openFirewall = true;
        openssl
        options = "--delete-older-than 2d";
        package = pkgs.lixPackageSets.stable.lix;
        persistent = true;
        pkg:
        pkgs.clamav
        ports = [ 3370 ];
        programs.nh = {
        randomizedDelaySec = "45min";
        reportInterval = "";
        root = {
        security.tpm2.enable = true;
        security.tpm2.pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
        security.tpm2.tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
        services.clear-log = {
        services.systembus-notify.enable = true;
        services.udev.packages = [
        services.usbguard.dbus.enable = true;
        services.usbguard.enable = true;
        services.usbguard.ruleFile = config.sops.secrets."usbguard".path;
        settings = {
        settings = {
        settings = pkgs.stubby.passthru.settingsExample // {
        sops.secrets."usbguard" = {
        sopsFile = ../../secrets/common.yaml;
        systemd.packages = with pkgs; [ usbguard-notifier ];
        systemd.user.services.usbguard-notifier.enable = true;
        timers.clear-log = {
        users.users.egor.extraGroups = [ "tss" ]; # tss group has access to TPM devices
        users.users.inti.extraGroups = [ "tss" ];
        virtualisation = {
        wget
      '';
      (mkIf cfg.tpm {
      (mkIf cfg.usbguard.sops {
      ];
      ];
      ];
      ];
      ];
      ];
      {
      }
      };
      };
      };
      };
      };
      };
      };
      };
      };
      };
      };
      };
      };
      };
      };
      };
      };
      };
      })
      })
      */
      */
      */
      */
      /*
      /*
      /*
      /*
      #  boot.kernelPackages = pkgs.linuxPackages_hardened;
      # $ nix search wget
      # Btrbk does not create snapshot directories automatically, so create one here.
      # Enable CUPS to print documents.
      # Enable networking
      # https://github.com/NixOS/nix/issues/6536
      # https://nixos.wiki/wiki/Storage_optimization#Automation
      # List packages installed in system profile. To search, run:
      # NIX_CONFIG="extra-access-tokens = github.com=github_pat_XYZ" nix ...
      # optional, useful when the builder has a faster internet connection than yours
      # probably not needed, the config has diffferent paths and the dir is empty
      # required, otherwise remote buildMachines above aren't used
      # Run garbage collection whenever there is less than 500MB free space left
      # Select internationalisation properties.
      # services.fstrim.interval
      # Set your time zone.
      # These builder-strings are used by the Nix terminal tool, e.g.
      # when calling "nix build ...".
      # You can see the resulting builder-strings of this NixOS-configuration with "cat /etc/nix/machines".
      ## Enable BBR
      ## Garbage collection
      ## Hardened kernel
      ## Network hardening and performance
      ## Optional: Clear >1 month-old logs
      #149.112.112.11
      #9.9.9.11
      #default = "default";
      #nix.settings.download-buffer-size = 524288000;
      boot.initrd.systemd.emergencyAccess = "$y$j9T$LSLJIAlFbp6k3cetejjE60$vcn.wkp7k/hmYG525hhkID5qCM8DXBQWsoqky.2kQ.4";
      boot.initrd.systemd.initrdBin = [
      boot.kernel.sysctl = {
      boot.kernelModules = [ "tcp_bbr" ];
      boot.plymouth.enable = true;
      default = false;
      default = false;
      default = false;
      default = false;
      default = false;
      default = false;
      default = false;
      default = false;
      default = false;
      default = false;
      default = false;
      documentation = {
      environment.shells = with pkgs; [ zsh ];
      environment.systemPackages = [
      environment.systemPackages = with pkgs; [
      hardware.bluetooth.enable = true; # enables support for Bluetooth
      hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boots
      hardware.bluetooth.settings = {
      i18n.defaultLocale = "es_ES.UTF-8";
      networking.firewall.enable = true;
      networking.hostName = cfg.hostname; # Define your hostname.
      networking.networkmanager.enable = true;
      nix = {
      nix.buildMachines = [
      nix.distributedBuilds = true;
      nix.extraOptions = ''
      nix.gc = {
      nix.settings = {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate =
      nixpkgs.overlays = [
      programs.adb.enable = true;
      programs.zoxide.enableZshIntegration = true;
      services.beesd.filesystems = {
      services.btrbk = {
      services.btrfs.autoScrub = {
      services.clamav.daemon.enable = true;
      services.clamav.updater.enable = true;
      services.earlyoom = {
      services.fstrim.enable = true;
      services.fwupd.enable = true;
      services.openssh = {
      services.printing.enable = true;
      services.smartd = {
      services.stubby = {
      services.systembus-notify.enable = true;
      sops.secrets."system/nix-token" = {
      specialisation = {
      system.autoUpgrade = {
      systemd = {
      systemd.enableEmergencyMode = true; # !!! TODO !!! TO REMOVE !!!
      systemd.tmpfiles.rules = [
      time.timeZone = "Europe/Madrid";
      type = types.bool;
      type = types.bool;
      type = types.bool;
      type = types.bool;
      type = types.bool;
      type = types.bool;
      type = types.bool;
      type = types.bool;
      type = types.bool;
      type = types.bool;
      type = types.bool;
      type = types.str;
      users.defaultUserShell = pkgs.zsh;
      users.groups.nixosvmtest = { };
      users.users.nixosvmtest.group = "nixosvmtest";
      users.users.nixosvmtest.initialPassword = "test";
      users.users.nixosvmtest.isSystemUser = true;
      virtualisation.vmVariant = {
    (mkIf cfg.autoupdate {
    (mkIf cfg.av {
    (mkIf cfg.btrfs {
    (mkIf cfg.cleanup {
    (mkIf cfg.distributed {
    (mkIf cfg.earlyoom {
    (mkIf cfg.hardening {
    (mkIf cfg.printing {
    (mkIf cfg.ssh {
    (mkIf cfg.usbguard.enable (mkMerge [
    ]))
    {
    }
    };
    };
    };
    };
    };
    };
    };
    };
    };
    };
    };
    };
    })
    })
    })
    })
    })
    })
    })
    })
    })
    autoupdate = mkOption {
    av = mkOption {
    btrfs = mkOption {
    cleanup = mkOption {
    distributed = mkOption {
    hardening = mkOption {
    hostname = mkOption {
    printing = mkOption {
    ssh = mkOption {
    tpm = mkOption {
    usbguard.enable = mkOption {
    usbguard.sops = mkOption {
  ...
  ];
  };
  #path = config.sops.secrets."system/hostkeys/luna/ed25519".path;
  #sops.secrets."system/hostkeys/luna/rsa" = {};
  cfg = config.modules.system;
  config = mkMerge [
  config,
  inputs,
  lib,
  options.modules.system = {
  pkgs,
{
{
}
}:
in
let
with lib;
