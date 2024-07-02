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
  modules.yubikey.enable = true;

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

  services.gvfs.enable = true;
  environment.systemPackages = with pkgs; [
    #mtpfs
    android-file-transfer
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-ocl
      intel-vaapi-driver
    ];
  };
  boot.kernelModules = ["nouveau" "bbswitch"];
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["modesetting" "nouveau"];

  hardware.bumblebee = {
    enable = true;
    group = "video";
    driver = "nouveau";
  };
  hardware.nvidia.package = "nouveau";

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
    sync.enable = true;

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
  };
  /*
     hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:14:0:0";
    # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  };
  */
  /*
     hardware.nvidia.prime = {
    sync.enable = true;

    # Make sure to use the correct Bus ID values for your system!
    nvidiaBusId = "PCI:14:0:0";
    intelBusId = "PCI:0:2:0";
    # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  };
  */
  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = ["on-the-go"];
      services.tailscale = {
        enable = lib.mkForce false;
      };
    };
  };

  /*
     nixpkgs.overlays = [
    (self: super: {
      bumblebee = super.bumblebee.override {
        nvidia_x11_i686 = null;
        libglvnd_i686 = null;
      };
      primus = super.primus.override {
        primusLib_i686 = null;
      };
    })
  ];
  */
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  networking.firewall.allowedTCPPorts = [33847];
}
