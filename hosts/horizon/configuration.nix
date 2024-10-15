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
    #./clevis.nix
    ./../common/users/egor.nix
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

  modules.gnome = {
    enable = true;
    autologin = true;
  };
  modules.impermanence = {
    enable = true;
    disk = "nvme";
  };
  modules.mullvad = {
    enable = true;
    impermanence = false;
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

  jovian.steam = {
    enable = true;
    autoStart = true;
    user = "egor";
    desktopSession = "gnome";
  };

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
  system.stateVersion = "23.11"; # Did you read the comment?

  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];
}
