# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  outputs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./services
    ./sops.nix
    ./disk-config.nix
    ./clevis.nix

    ./../common/users/egor.nix
    ./../common/users/inti.nix
    ./../common/users/root.nix
    #./../common/desktop/steam.nix
    ./../common/desktop/virtualbox.nix

    #./odoo-test.nix # add to specializations or flake/shell
  ]
  ++ (builtins.attrValues outputs.nixosModules);

  modules.gnome = {
    enable = true;
    autologin = false;
  };
  modules.ollama = {
    enable = true;
  };

  modules.yggdrasil = {
    enable = false;
    persist = true;
  };

  modules.impermanence = {
    enable = true;
    disk = "nvme";
  };

  modules.steam.enable = true;

  modules.xonsh.enable = true;

  modules.sound.enable = true;

  modules.tailscale = {
    enable = true;
    exit = false;
    hostname = "stellar";
    impermanence = true;
  };

  modules.system = {
    hostname = "stellar";
    ssh = true;
    printing = true;
    autoupdate = true;
    cleanup = true;
    hardening = true;
    usbguard = {
      enable = false;
      sops = true;
    };
    tpm = true;
    btrfs = true; # !!! can be  actually done with config.filesystems... like if btrfs is true then this
  };

  modules.yubikey.enable = true;

  networking.firewall = {
    allowedTCPPorts = [
      #11434
      #1080
      33333
    ];
    #allowedUDPPorts = [
    #];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  stdenv.hostPlatform.stateVersion = "24.11"; # Did you read the comment?

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #services.logrotate.checkConfig = false; # TODO check logrotate

  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
    # inputs.plasma-manager.homeModules.plasma-manager
  ];
  environment.systemPackages = with pkgs; [
    xf86_input_wacom
    opentabletdriver
    pinta

    #easyeffects
    /*
      fprintd-tod
       fprintd
       open-fprintd
       libfprint-tod
       libfprint
       libfprint-2-tod1-goodix-550a
       libfprint-2-tod1-goodix
    */

  ];
  /*
    services.udev.packages = [
      pkgs.android-udev-rules
    ];
  */
  programs.adb.enable = true;
  users.users.egor.extraGroups = [
    "adbusers"
    "podman"
  ];
  users.users.inti.extraGroups = [
    "adbusers"
    "podman"
  ];

  #systemd.services.nix-daemon.serviceConfig.EnvironmentFile = "/etc/nixos/nix-daemon-environment";

  /*
    # Start the driver at boot
    systemd.services.fprintd = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
    };
  */

  /*
    # Install the driver
    services.fprintd.enable = true;
    # If simply enabling fprintd is not enough, try enabling fprintd.tod...
    services.fprintd.tod.enable = true;
    # ...and use one of the next four drivers
    services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
    #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-elan; # Elan(04f3:0c4b) driver
    #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090; # driver for 2016 ThinkPads
    #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a; # Goodix 550a driver (from Lenovo)
    security.pam.services.login.fprintAuth = false;
    security.pam.services.gdm-fingerprint = lib.mkIf (config.services.fprintd.enable) {
      text = ''
        auth       required                    pam_shells.so
        auth       requisite                   pam_nologin.so
        auth       requisite                   pam_faillock.so      preauth
        auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
        auth       optional                    pam_permit.so
        auth       required                    pam_env.so
        auth       [success=ok default=1]      ${pkgs.gdm}/lib/security/pam_gdm.so
        auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so

        account    include                     login

        password   required                    pam_deny.so

        session    include                     login
        session    optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
      '';
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "libfprint-2-tod1-goodix"
        "libfprint-2-tod1-elan"
        "libfprint-2-tod1-vfs0090"
        "libfprint-2-tod1-goodix-550a"
      ];
  */
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl88xxau-aircrack
  ];
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
  # LAPTOP STUFF - NEW
  services.logind.settings.Login.HandleLidSwitch = "poweroff";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "lock";
  #services.logind.lidSwitchDocked = "ignore";
  # one of "ignore", "poweroff", "reboot", "halt", "kexec", "suspend", "hibernate", "hybrid-sleep", "suspend-then-hibernate", "lock"

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  services.thermald.enable = true;

  programs.niri.enable = true;

  hardware.graphics.enable = true;
}
