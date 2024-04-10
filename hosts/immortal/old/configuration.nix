# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ./services

    ./../common/users/egor.nix
    #TODO - new keys
    ./../common/users/root.nix
    ./sops.nix
    #./disk-config.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      #outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    #    config = {
    #      # Disable if you don't want unfree packages
    #      allowUnfree = true;
    #    };
  };
  #FIXME - Maybe move this part somewhere else
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # FIXME - Check if if needs to be removed
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # TODO: Set your hostname
  networking.hostName = "immortal";
  # FIXME - Find a place for it
  services.logrotate.checkConfig = false;

  boot.kernelParams = ["systemd.machine_id=c13317057dead3d74b8938a46544e8f3" "systemd.condition-first-boot=false"];
  services.localtimed.enable = true;
  time.timeZone = "Asia/Bangkok";

  #systemd.services.ModemManager.enable = true;
  #  systemd.services.modem = {
  #    path = [ pkgs.modemmanager ];
  #    script = ''
  #        exec mmcli
  #    '';
  #    serviceConfig = {
  #        Restart = "always";
  #        RestartSec = 10;
  #    };
  #    wantedBy = [ "multi-user.target" ];
  #  };
  # enables usb-modeswitch, also useful for USB WiFi adapter that enumerates as CDROM, by default
  hardware.usb-modeswitch.enable = true;

  # ModemManager needs polkit so keep it active although this is a headless system
  security.polkit.enable = lib.mkForce true;

  # ModemManager doesn't seem to start if we don't request it.z
  #systemd.services.ModemManager.wantedBy = ["multi-user.target"];

  # FIXME - Move it somewhere else
  # FIXME - Fix it
  # Use btrbk to snapshot persistent states and home
  #services.btrbk.instances.btrbk = {
  # snapshot on the start and the middle of every hour.
  #  onCalendar = "*:00,30";
  #  settings = {
  #    timestamp_format = "long-iso";
  #    preserve_day_of_week = "monday";
  #    preserve_hour_of_day = "23";
  # All snapshots are retained for at least 6 hours regardless of other policies.
  #    snapshot_preserve_min = "6h";
  #    volume."/" = {
  #      snapshot_dir = ".snapshots";
  #      subvolume."persist".snapshot_preserve = "48h 7d";
  #      subvolume."home".snapshot_preserve = "48h 7d 4w";
  #    };
  #  };
  #};
  # FIXME - Find a place for it
  programs.zsh.enable = true;

  # Scrub btrfs to protect data integrity
  services.btrfs.autoScrub.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.logind.powerKey = "ignore";
  services.logind.suspendKey = "ignore";
  services.logind.hibernateKey = "ignore";
  services.logind.rebootKey = "ignore";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  # FIXME - This is a mess
  users = {
    mutableUsers = false; # Disable passwd

    users = {
      root = {
        #hashedPassword = "*"; # Disable root password
        #isNormalUser = true;
      };
      #     egor = {
      ##        passwordFile = "/persist/passwords/egor";
      #       isNormalUser = true;
      #        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      #        openssh.authorizedKeys.keys = [
      ##          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBaN1oBtFtVh2s6IlpuNIZSxTzxYGiHL1ub/TPREQnuN egor@ctemplar.com"
      #         "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCZ+eHF+PNZxA3B1DmwGQ3SFqmOrx8Tq9iYL4zrNplk3dknZCK1Ob6jNzrPwJruQztX1ckoBEgUvYLeTQk1+nWZxgrssCr4WX7QzaP0cRnVbw+JGSenf635Df0+Ni07xvl1UnszNgnK4/DHyRHVTJPQjm1lIjJIzUxgfHUphYpfaQCxTYvrNDsraTTFuljtpT7m1YFT2D62w5y75UaFMJSVvg4fQMhSQl7BBjBtsHjfqKa8f2dabGgbAhVaW7rQszZO48ztSziIprWbIzuR3ABQnAHXkIxhSrU/SMJzBqhImPNpgBqFaB/AxdnGQ4jpjsbNqT57tadu24dzZDxrLwqDLV4AA1pcT3DGqyU1YQyqfTMJlXA0w+JSus+zTKDZWRajxcnoykVfwcv3nk1gkSFpu8AcNOZ+2XciLY6kW6IFRgjhRqwbiS69kr5PO8Epy/S3rdS1SCGvqnQN1PpMrDF89nCLIhV7wxe/Jw7ZTJPODnb/Y3Hfc6iLvWYzXP/i91E= egor@egor-laptop"
      #        ];
      #      };
      #      wordpress = {
      #        isNormalUser = true;
      #        #extraGroups = [ "wordpress" ];
      #        group = "wordpress";
      #      };
    };
    groups = {
      media = {
        members = ["transmission" "jellyfin" "sonarr" "radarr" "jellyseerr"];
      };
      sync = {
        members = ["syncthing" "photoprism" "egor"];
      };
      nginx = {
        members = ["adguardhome"];
      };
      mysql = {
        members = ["photoprism"];
      };
      wwwrun = {
        members = ["wordpress"];
      };
    };
  };

  # FIXME - Find a place for it
  environment.systemPackages = with pkgs; [
    git
    tmux
    wget
    dnsutils
    openssl
    cryptsetup
    tailscale
    mosh
    deploy-rs
    nc4nix
    modemmanager
    mobile-broadband-provider-info
    usb-modeswitch
    usb-modeswitch-data
    tpm2-tss
  ];
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.mosh.enable = true;

  # FIXME - Find a place for it
  #security.pam = {
  #  services.login.googleAuthenticator.enable = true;
  #  services.sudo.googleAuthenticator.enable = true;
  #};

  # FIXME - Find a place for it
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443 8080 8000 4430 25564 25565];
    #allowedUDPPorts = [ ];
    #interfaces."podman0".allowedTCPPorts = [ 9980 ];
    #interfaces."lo".allowedTCPPorts = [ 9980 ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
