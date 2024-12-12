# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./services
    ./sops.nix
    ./disk-config.nix
    ./asteriks.nix
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
    outputs.nixosModules.yubikey
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
  #modules.steam.enable = true;
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
    autoupdate = true;
    cleanup = true;
    hardening = true;
    usbguard = {
      enable = false;
      sops = true;
    };
  };
  modules.yubikey.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.logrotate.checkConfig = false;

  /*
     services.radicle = {
    #httpd.enable = true;
    enable = true;
    publicKey = "/home/egor/.radicle/keys/radicle.pub";
    privateKeyFile = "/home/egor/.radicle/keys/radicle";
    settings = {
      web.pinned.repositories = [
        "rad:z3gqcJUoA1n9HaHKufZs5FCSGazv5" # heartwood
        "rad:z3trNYnLWS11cJWC6BbxDs5niGo82" # rips
        "rad:z3X6L7xk4KwQZvQng1SvzYZz9JeHn"
      ];
    };
  };
  */
  environment.systemPackages = with pkgs; [
    radicle-node
    maven
  ];
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
  system.stateVersion = "23.11"; # Did you read the comment?
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-28.3.3"
    "electron-27.3.11"
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "davinci-resolve"
      "steam"
      "steam-original"
      "steam-run"
      "nvidia-x11"
      "nvidia-settings"
      "intel-ocl"
    ];
  /*
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };
  */
  hardware.opengl = {
    # hardware.graphics on unstable
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
      # your Open GL, Vulkan and VAAPI drivers
      vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
      onevpl-intel-gpu # for newer GPUs on NixOS <= 24.05
      intel-media-sdk # for older GPUs
    ];
  };
  #environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [intel-vaapi-driver];
}
