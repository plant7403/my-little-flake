# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ ...}: {
  imports = [
    <nixos-avf/avf>
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./services
    ./sops.nix
  ];
  #modules.gnome = {
  #  enable = true;
  /*
  autologin = true;
  */
  #};
  /*
     modules.impermanence = {
    enable = true;
    disk = "vda3";
  };
  */
  /*
     modules.tailscale = {
    enable = true;
    exit = true;
    hostname = "pluto";
    impermanence = true;
  };
  */
  modules.system = {
    hostname = "comet";
    ssh = true;
    printing = false;
    cleanup = true;
    hardening = true;
    usbguard = {
      enable = false;
      sops = false;
    };
  };

  # Bootloader.
  /*
  boot.loader.grub.devices = ["/dev/vda3"];
  */

  networking.hostName = "comet"; # Define your hostname.

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
