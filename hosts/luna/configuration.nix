# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
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
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
    inputs.nixos-hardware.nixosModules.microsoft-surface-go
  ];
  #services.pppd.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  services.udisks2.enable = true;
  #hardware.usbWwan.enable = true;

  microsoft-surface.surface-control.enable = true;
  microsoft-surface.kernelVersion = "6.6";
  #hardware.microsoft-surface.firmware.surface-go-ath10k.replace = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

  services.udev.packages = [
    pkgs.yubikey-personalization
    pkgs.gnome.gnome-settings-daemon
    pkgs.yubikey-touch-detector
    pkgs.usb-modeswitch-data
  ];
  programs.dconf.enable = true;

  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];
  nix.settings = {
    extra-substituters = ["https://cachix.cachix.org"];
    extra-trusted-public-keys = ["cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="];
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  #services = {
  #  howdy = {
  #    enable = true;
  #    package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
  #    settings = {
  #      video.device_path = "/dev/video2";
  #      # you may not need these
  #      core.no_confirmation = true;
  #      video.dark_threshold = 90;
  #    };
  #  };

  # in case your IR blaster does not blink, run `sudo linux-enable-ir-emitter configure`
  # linux-enable-ir-emitter = {
  #  enable = true;
  #  package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
  # };
  #};

  users.users.egor = {
    isNormalUser = true;
    description = "Egor";
    extraGroups = ["networkmanager" "wheel"];
  };

  #programs.adb.enable = true;
  #users.users.egor.extraGroups = [ "adbusers" ];
  #services.udev.packages = [
  #  pkgs.android-udev-rules
  #];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.logrotate.checkConfig = false;

  networking.hostName = "luna"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    #wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = false;
  #services.xserver.displayManager.autoLogin.user = "egor";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    age-plugin-yubikey
    deploy-rs
    git
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    ntfs3g
    python3
    (pkgs.python3.withPackages my-python-packages)
    tailscale-systray
    wget
    yubico-piv-tool
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization
    yubikey-personalization-gui
    yubioath-flutter
    yubikey-touch-detector
    wl-clipboard
    ppp
    modem-manager-gui
  ];

  programs.steam = {
    enable = true;
    #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.direnv.enable = true;
  programs.yubikey-touch-detector.enable = true;

  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "davinci-resolve"
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boots
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };
  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [22];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  sops.secrets."system/ip/pluto" = {};
}
