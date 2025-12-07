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
}:
let
  my-python-packages =
    ps: with ps; [
      pandas
      requests
      # other python packages
    ];
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./services
    ./sops.nix
    ./clevis.nix
    #./clevis.nix
    ./../common/users/egor.nix
    ./../common/users/root.nix

    ./disk-config.nix
    #./ssh.nix
    #./camera.nix
    outputs.nixosModules.gnome
    outputs.nixosModules.kde
    outputs.nixosModules.impermanence
    #outputs.nixosModules.mullvad
    outputs.nixosModules.sound
    outputs.nixosModules.steam
    outputs.nixosModules.tailscale
    outputs.nixosModules.system
    outputs.nixosModules.yubikey
    outputs.nixosModules.transmission
    outputs.nixosModules.web
    outputs.nixosModules.yggdrasil
    outputs.nixosModules.ollama
  ];

  modules.gnome = {
    enable = true;
    autologin = true;
    isSteamDeck = true;
    #remote = true;
  };
  modules.ollama = {
    enable = true;
  };
  # modules.kde.enable = true;
  modules.impermanence = {
    enable = true;
    disk = "nvme";
  };
  /*
       modules.mullvad = {
      enable = true;
      impermanence = true;
    };
  */
  modules.yggdrasil = {
    enable = true;
    persist = true;
  };
  modules.sound.enable = true;
  modules.steam.enable = true;
  /*
       modules.tailscale = {
      enable = true;
      exit = false;
      hostname = "horizon";
      impermanence = true;
    };
  */
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
    tpm = true;
  };
  modules.yubikey.enable = true;

  programs.xwayland.enable = true;
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = "egor";
      desktopSession = "gnome";
      updater.splash = "jovian";
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
  environment.persistence."/persist".directories = [
    "/var/lib/decky-loader"
  ];
  nixpkgs.config.allowUnfree = true;
  programs = {
    nix-ld.enable = true;
  };
  boot.kernelParams = [ "clearcpuid=514" ];

  modules.transmission = {
    enable = true;
    sops = true;
    persist = true;
  };

  environment.systemPackages = [
    #pkgs.protonup-qt
    pkgs.lutris
    pkgs.steamdeck-firmware

    pkgs.ryubing
    pkgs.steam-rom-manager

    #pkgs.heroic
    pkgs.protontricks

    /*
      pkgs.maliit-framework
       pkgs.maliit-keyboard
    */
    # support both 32- and 64-bit applications
    pkgs.wineWowPackages.stable

    # support 32-bit only
    pkgs.wine

    # support 64-bit only
    (pkgs.wine.override { wineBuild = "wine64"; })

    # wine-staging (version with experimental features)
    pkgs.wineWowPackages.staging

    # winetricks (all versions)
    pkgs.winetricks

    # native wayland support (unstable)
    pkgs.wineWowPackages.waylandFull

    pkgs.lz4
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    lz4
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    lz4

    glib # libgobject-2.0.so.0, libglib-2.0.so.0, libgio-2.0.so.0
    nss # libnss3.so, libnssutil3.so, libsmime3.so
    nspr # libnspr4.so
    at-spi2-atk # libatk-1.0.so.0, libatk-bridge-2.0.so.0
    cups.lib # libcups.so.2
    dbus.lib # libdbus-1.so.3
    libdrm # libdrm.so.2
    gdk-pixbuf # libgdk_pixbuf-2.0.so.0
    #gtk3 # libgtk-3.so.0
    pango # libpango-1.0.so.0
    cairo # libcairo.so.2
    xorg.libX11 # libX11.so.6
    xorg.libXcomposite # libXcomposite.so.1
    xorg.libXdamage # libXdamage.so.1
    xorg.libXext # libXext.so.6
    xorg.libXfixes # libXfixes.so.3
    xorg.libXrandr # libXrandr.so.2
    mesa # libgbm.so.1
    expat # libexpat.so.1
    xorg.libxcb # libxcb.so.1
    libxkbcommon # libxkbcommon.so.0
    alsa-lib # libasound.so.2
    at-spi2-atk # libatspi.so.0
    libgbm
    # here, NOT in environment.systemPackages
  ];
  services.ollama = {
    acceleration = "rocm";
    /*
      environmentVariables = {
           HCC_AMDGPU_TARGET = "gfx1033"; # used to be necessary, but doesn't seem to anymore
         };
    */
    # results in environment variable "HSA_OVERRIDE_GFX_VERSION=10.3.0"
    rocmOverrideGfx = "10.3.0";
  };

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

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
