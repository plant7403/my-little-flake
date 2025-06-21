# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  outputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./services
    ./sops.nix
    ./disk-config.nix
    ./../common/users/root.nix
    ./../common/users/egor.nix
    ./clevis.nix
    #./postgres-migrate.nix
    ./../common/optional/postgresql/default.nix
    ./../common/optional/mysql/default.nix
    outputs.nixosModules.impermanence
    outputs.nixosModules.tailscale
    outputs.nixosModules.system
    outputs.nixosModules.yubikey
    outputs.nixosModules.authelia
    outputs.nixosModules.transmission
    outputs.nixosModules.web
  ];

  modules.impermanence = {
    enable = true;
    disk = "nvme";
  };
  modules.tailscale = {
    enable = true;
    exit = true;
    hostname = "immortal";
    impermanence = true;
  };
  modules.system = {
    hostname = "immortal";
    ssh = true;
    printing = false;
    autoupdate = true;
    cleanup = true;
    #hardening = true;
    usbguard = {
      enable = true;
      sops = false;
    };
  };
  modules.yubikey.enable = true;

  modules.transmission = {
    enable = true;
    web = true;
    sops = true;
    persist = true;
    user = "transmission";
    group = "media";
    download-dir = "/hdd/Media";
  };

  modules.authelia.enable = true;

  services.yggdrasil = {
    openMulticastPort = true;
    enable = true;
    persistentKeys = true;
    settings = {
      Peers = [
        "quic://spain.magicum.net:36900"
        "tls://spain.magicum.net:36901"
        "tcp://rendezvous.anton.molyboha.me:50421"
      ];
    };
  };

  /*
       services.ollama = {
      enable = true;
      host = "0.0.0.0";
      #acceleration = "cuda";
    };
  */
  networking.firewall = {
    allowedTCPPorts = [
      11434
      1080
      
    ];
    allowedUDPPorts = [
      1080
    ];
  };

  systemd.services.nix-daemon.environment.TMPDIR = "/tmp";

  #boot.runSize =
  #boot.tmp.cleanOnBoot = true;
  #boot.tmp.useTmpfs = true;
  #powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # High-DPI console
  #console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  environment.persistence."/persist".directories = [
    "/etc/secureboot"
    "/data"
  ];

  # Bootloader.
  #boot.loader.grub.devices = ["/dev/vda3"];
  services.logrotate.checkConfig = false;
  #services.postgresql.package = pkgs.postgresql_14;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd = {
    enable = true;
    supportedFilesystems = [ "btrfs" ];
  };

  services.logind.powerKey = "ignore";
  services.logind.suspendKey = "ignore";
  services.logind.hibernateKey = "ignore";
  services.logind.rebootKey = "ignore";

  system.stateVersion = "23.11"; # Did you read the comment?

  #systemd.services.adguard-home = {
  #before = "";
  #};
  /*
    networking = {
      interfaces.ens3 = {
        ipv6.addresses = [
          {
            address = "2405:4802:1d0b:d270:::1";
            prefixLength = 64;
          }
        ];
        ipv4.addresses = [
          {
            address = "192.0.1.100";
            prefixLength = 24;
          }
        ];
      };
      defaultGateway = {
        address = "192.0.1.1";
        interface = "ens3";
      };
      defaultGateway6 = {
        address = "fe80::1";
        interface = "ens3";
      };
    };
  */
  systemd.services.cfdyndns = {
    after = [
      "adguard-home.service"
    ];
  };
  systemd.services.headscale = {
    after = [
      "cfdyndns.service"
      "nginx.service"
      "authelia-prod.service"
    ];
  };
  systemd.services.tailscale = {
    after = [
      "headscale.service"
    ];
  };
  systemd.services.nginx = {
    after = [
      "adguard-home.service"
    ];
  };
  systemd.services.authelia-prod = {
    after = [
      "nginx.service"
    ];
  };
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-wrapped-6.0.36"
    "aspnetcore-runtime-6.0.36"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-6.0.428"
  ];
  services._3proxy = {
    enable = true;
    services = [
      {
        type = "socks";
        auth = [ "strong" ];
        acl = [
          {
            rule = "allow";
            users = [ "test1" ];
          }
        ];
      }
    ];
    usersFile = "/etc/3proxy.passwd";
  };

  environment.etc = {
    "3proxy.passwd".text = ''
      test1:CL:password1
      test2:CR:$1$rkpibm5J$Aq1.9VtYAn0JrqZ8M.1ME.
    '';
  };
}
/*
  adguard
  cfdyndns
  headscale
  tailscale
*/
