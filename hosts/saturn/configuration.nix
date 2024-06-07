# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./services
    ./sops.nix
    ./disk-config.nix
    ./../common/users/egor.nix
    ./../common/users/root.nix
    #./../common/desktop/steam.nix
    ./../common/desktop/virtualbox.nix
    outputs.nixosModules.gnome
    outputs.nixosModules.impermanence
    outputs.nixosModules.mullvad
    outputs.nixosModules.sound
    outputs.nixosModules.steam
    outputs.nixosModules.tailscale
    outputs.nixosModules.system
  ];

  modules.gnome = {
    enable = true;
    autologin = true;
  };
  modules.impermanence = {
    enable = true;
    disk = "ssd";
  };
  modules.mullvad = {
    enable = true;
    impermanence = true;
  };
  modules.sound.enable = true;
  modules.steam.enable = true;
  modules.tailscale = {
    enable = true;
    exit = false;
    hostname = "saturn";
    impermanence = true;
  };
  modules.system = {
    hostname = "saturn";
    ssh = true;
    printing = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.logrotate.checkConfig = false;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  programs.direnv.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
