# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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
    ./clevis.nix
    ./../common/users/egor.nix
    #./ssh.nix
    #./camera.nix
    inputs.hardware.nixosModules.microsoft-surface-common
    inputs.hardware.nixosModules.microsoft-surface-go
    outputs.nixosModules.gnome
    outputs.nixosModules.impermanence
    outputs.nixosModules.mullvad
    outputs.nixosModules.sound
    #outputs.nixosModules.steam
    outputs.nixosModules.tailscale
    outputs.nixosModules.system
    outputs.nixosModules.yubikey
  ];

  modules.gnome = {
    enable = true;
    autologin = false;
  };
  #modules.impermanence = {
  #  enable = true;
  #  disk = "ssd";
  #};
  modules.mullvad = {
    enable = true;
    impermanence = false;
  };
  modules.sound.enable = true;
  #modules.steam.enable = true;
  modules.tailscale = {
    enable = true;
    exit = false;
    hostname = "luna";
    impermanence = false;
  };
  modules.system = {
    hostname = "luna";
    ssh = true;
    printing = false;
  };
  modules.yubikey.enable = true;

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs

    # here, NOT in environment.systemPackages
  ];
  #services.pppd.enable = true;
  #security.polkit.enable = true;
  #services.accounts-daemon.enable = true;
  #services.udisks2.enable = true;
  #hardware.usbWwan.enable = true;

  #microsoft-surface.surface-control.enable = true;
  microsoft-surface.kernelVersion = "6.6";
  #hardware.microsoft-surface.firmware.surface-go-ath10k.replace = true;
  #hardware.enableRedistributableFirmware = true;
  #nixpkgs.config.allowUnfree = true;

  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.logrotate.checkConfig = false;

  programs.direnv.enable = true;
  #programs.yubikey-touch-detector.enable = true;

  hardware.opengl.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boots
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-28.3.3"
    "electron-27.3.11"
  ];
}
