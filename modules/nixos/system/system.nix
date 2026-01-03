{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.system;
in
{
  /*
    imports = [

    ];
  */
  options.modules.system = {
    ssh = mkOption {
      type = types.bool;
      default = false;
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
    docs = mkOption {
      type = types.bool;
      default = false;
    };
    vmtest = mkOption {
      type = types.bool;
      default = false;
    };
    shell = mkOption {
      type = types.bool;
      default = false;
    };
    emergency = mkOption {
      type = types.bool;
      default = false;
    };
    info = {
      hostname = mkOption {
        type = types.str;
      };
      user = mkOption {
        type = types.str;
        default = "egor";
      };
      flakePath = mkOption {
        type = types.str;
        default = "/home/egor/my-little-flake";
      };
    };

  };
  config = mkMerge [
    {
      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = cfg.info.hostname;
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

      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
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
    (mkIf cfg.vmtest {
      users.users.nixosvmtest.isSystemUser = true;
      users.users.nixosvmtest.initialPassword = "hellohowareyou?";
      users.groups.nixosvmtest = { };
      users.users.nixosvmtest.group = "nixosvmtest";

      sops.secrets."encryption/stellar" = { };
      #'.#nixosConfigurations.mymachine.config.system.build.vmWithDisko'
      /*
        boot.initrd.network.ssh = {
          enable = true;
          port = 2222;
          shell = "/bin/cryptsetup-askpass";
          authorizedKeys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4OqADgjR4tD/2BFBTfhoi8AchffLyayrr0X5FSKC00ONzNpYeynuw9+bVbZ5a+O1EI3PPyCXKlmC4U3ZGl/jJWauhyXvT0068LC+hVwJfBwrHNbaq9b1Urgz2Mcv2tX9jbpi0hnxHwCQDTNtXptgxDvSLdz86gc6cBg48Y0cntSeNbHbvWFrcZ0iXUJYMpSVHNKPyR25r7SeNtXFvXzPTjPq/+wGsfnhXqbNDwec41zMsc4TBxHVKELFa1AaQF4QQ2SPQsWLSJ151EkybM4OfBxLulgqCzBYkHfjlqWuQqCwN9DOgFimoFLWJT9f8PUOHsu8q0ryTx7viyiFXK51enMGvthP4uRLWn6WdDb7zhe48HGbkWkVXETx78u5bL7hyIlMu9L3AB8gWKI7BYD+FrUyZkasK/e+JO0ECoil4c6jasqInvLVcyQY0loVyppL89CGTZZfTreZLv4Tt6rFuF9sBQ/FqDuA2L2wRgPZKRj1HiO3pppiAKuu5EG2Faotoi49WqM+RJD6O1RG7jWjCYKHB8TfiqrObJt9YRjYBctbWlNzZQs6oC1hKsLkfx1fjSA8PLDevPvK5jPgU6cUEFK22GouVxbdp8ZicTsi7AK6xGxJ2uENPAMFIuh6tqU6u9nI7mceK0vv343Y3pvvc0MawH/nS4+kIG57lL8hnNQ== cardno:19_271_673"
          ];
          hostKeys = [
            /boot/ssh_host_initrd_ed25519_key
            /boot/ssh_host_initrd_rsa_key
          ];
        };
      */

      /*
        boot.initrd.secrets = lib.mkForce {
          "/etc/secret" = /etc/secret;
        };
      */

      virtualisation = {
        vmVariantWithDisko = {
          virtualisation.fileSystems."/persist".neededForBoot = mkForce true;
          virtualisation.disko.devices.disk.nvme.imageSize = "10GB";
          virtualisation.disko.memSize = 2048;
          virtualisation.cores = 3;
          virtualisation.boot.initrd.secrets = lib.mkForce {
            "/etc/secret" = /etc/secret;
          };
          /*
            fileSystems."/persist".neededForBoot = neededForBoot true;
            disko.devices.disk.nvme.content.partitions.luks.content.passwordFile =
            lib.mkForce
              config.sops.secrets."encryption/stellar".path;
          */
          #memorySize = 2048;

          #diskImage = lib.mkOverride 10 null;
        };
      };
    })
    (mkIf cfg.emergency {
      boot.initrd.systemd.emergencyAccess = "$y$j9T$LSLJIAlFbp6k3cetejjE60$vcn.wkp7k/hmYG525hhkID5qCM8DXBQWsoqky.2kQ.4";
      boot.initrd.systemd.initrdBin = [ ];
      systemd.enableEmergencyMode = true; # !!! TODO !!! TO REMOVE !!!
    })

    (mkIf cfg.ssh {
      services.openssh = {
        enable = true;
        ports = [ 3370 ];
        openFirewall = true;
        settings.PasswordAuthentication = false;
        settings.challengeResponseAuthentication = false;
        extraConfig = ''
          # syntax: sh
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
        extraOptions = ''min-free = ${toString (5000 * 1024 * 1024)}'';
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
        flake = "git:git.disroot.org/me/my-little-flake";
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
  ];
}
