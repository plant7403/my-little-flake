# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
/*
!! THIS IS HOW TO RUN NIXOS ANYWHERE (almost)
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/horizon/hardware-configuration.nix --build-on-remote --copy-host-keys --extra-files /persist/sops-nix/ --flake flake.nix#horizon root@192.168.1.159
!! THEN BOOT INTO USB AGAIN
cryptsetup /dev/nvme0n1 name
mount name name/
cd name
btrfs subvolume snapshot -r @ROOT @ROOT-BLANK
!! TO ADD SOPS KEYS
edit .sops.yaml
*/
{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: let
  my-python-packages = ps:
    with ps; [
      pandas
      requests
      # other python packages
    ];
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./services
    ./sops.nix
    #./clevis.nix
    ./../common/users/egor.nix
    ./../common/users/root.nix

    ./disk-config.nix
    #./ssh.nix
    #./camera.nix
    outputs.nixosModules.gnome
    outputs.nixosModules.impermanence
    outputs.nixosModules.mullvad
    outputs.nixosModules.sound
    #outputs.nixosModules.steam
    outputs.nixosModules.tailscale
    outputs.nixosModules.system
    outputs.nixosModules.yubikey
  ];

  #modules.gnome = {
  #  enable = true;
  /*
  autologin = true;
  */
  #};
  modules.impermanence = {
    enable = true;
    disk = "nvme";
  };
  modules.mullvad = {
    enable = true;
    impermanence = true;
  };
  modules.sound.enable = true;
  #modules.steam.enable = true;
  modules.tailscale = {
    enable = true;
    exit = false;
    hostname = "horizon";
    impermanence = true;
  };
  modules.system = {
    hostname = "horizon";
    ssh = true;
    printing = false;
    cleanup = true;
    hardening = true;
    usbguard = {
      enable = false;
      sops = false;
    };
  };
  modules.yubikey.enable = true;

  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = "egor";
      desktopSession = "gnome";
    };
    decky-loader = {
      enable = true;
      package = pkgs.decky-loader-prerelease;
    };
    devices.steamdeck = {
      enable = true;
      autoUpdate = true;
      enableGyroDsuService = true;
    };
  };
  services.xserver.desktopManager.gnome.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs = {
    nix-ld.enable = true;
  };
  services.transmission = {
    package = pkgs.transmission_4;
    webHome = pkgs.flood-for-transmission;
    openFirewall = true;
    openRPCPort = true;
    enable = true;
    user = "egor";
    group = "users";
    settings = {
      #home = "/home/egor/.transmission";
      #watch-dir = "/DATA/D1/TM/watch";
      incomplete-dir-enabled = false;
      download-dir = "/home/egor/Downloads";
      watch-dir-enabled = false;
      rpc-bind-address = "0.0.0.0";
      rpc-port = 9099;
      rpc-whitelist = "192.168.1.*, 127.0.0.1";
    };
  };

  environment.systemPackages = [
    pkgs.protonup-qt
    pkgs.lutris
    pkgs.steamdeck-firmware

    pkgs.ryujinx
    pkgs.steam-rom-manager

    pkgs.heroic
    pkgs.protontricks

    pkgs.jellyfin-media-player

    pkgs.maliit-framework
    pkgs.maliit-keyboard
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs

    # here, NOT in environment.systemPackages
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];

  #services.pppd.enable = true;
  #security.polkit.enable = true;
  #services.accounts-daemon.enable = true;
  #services.udisks2.enable = true;
  #hardware.usbWwan.enable = true;

  #nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #services.logrotate.checkConfig = false;

  programs.direnv.enable = true;
  #programs.yubikey-touch-detector.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];
}
