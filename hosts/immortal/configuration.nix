# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  outputs,
  ...
}: {
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
  };

  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    #acceleration = "cuda";
  };
  networking.firewall = {
    allowedTCPPorts = [11434];
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
    supportedFilesystems = ["btrfs"];
  };

  services.logind.powerKey = "ignore";
  services.logind.suspendKey = "ignore";
  services.logind.hibernateKey = "ignore";
  services.logind.rebootKey = "ignore";

  system.stateVersion = "23.11"; # Did you read the comment?

  #systemd.services.adguard-home = {
  #before = "";
  #};
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
}
/*
adguard
cfdyndns
headscale
tailscale
*/

