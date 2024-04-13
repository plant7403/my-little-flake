# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./services
    ./sops.nix
    ./disk-config.nix
    ./../common/users/root.nix
    ./../common/users/egor.nix
    ./clevis.nix
    #./postgres-migrate.nix
  ];

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };
  #powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # High-DPI console
  #console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
            environment.persistence."/persist" = {
              directories = ["/etc/secureboot"
"/var/lib/private/ntfy-sh"
"/var/lib/postgresql"
"/var/lib/forgejo"
"/var/lib/bitwarden_rs"
"/var/lib/authelia-prod"
];
            };
  # Bootloader.
  #boot.loader.grub.devices = ["/dev/vda3"];
  services.logrotate.checkConfig = false;
  #services.postgresql.package = pkgs.postgresql_14;
  networking.hostName = "immortal"; # Define your hostname.
  services.fwupd.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  boot.kernelParams = ["systemd.machine_id=c13317057dead3d74b8938a46544e8f3" "systemd.condition-first-boot=false"];
  services.localtimed.enable = true;

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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd = {
    enable = true;
    supportedFilesystems = ["btrfs"];
  };

  services.logind.powerKey = "ignore";
  services.logind.suspendKey = "ignore";
  services.logind.hibernateKey = "ignore";
  services.logind.rebootKey = "ignore";

  environment.systemPackages = with pkgs; [
    wget
    git
    nano
    borgbackup
    restic
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [22];
  #networking.firewall.allowedUDPPorts = [ 22 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
