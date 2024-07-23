{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system;
in {
  options.modules.system = {
    printing = mkOption {
      type = types.bool;
      default = false;
    };
    ssh = mkOption {
      type = types.bool;
      default = false;
    };
    hostname = mkOption {
      type = types.str;
      #default = "default";
    };
  };

  config = mkMerge [
    {
      nix.settings.experimental-features = ["flakes" "nix-command"];
      nix.settings = {
        extra-substituters = ["https://cachix.cachix.org"];
        extra-trusted-public-keys = ["cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="];
      };

      networking.hostName = cfg.hostname; # Define your hostname.

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

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        wget
        git
        nano
      ];
      services.fwupd.enable = true;

      # Enable networking
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;
    }
    (mkIf cfg.printing {
      # Enable CUPS to print documents.
      services.printing.enable = true;
    })
    (mkIf cfg.ssh {
      services.openssh = {
        enable = true;
        ports = [3370];
        openFirewall = true;
        settings = {
          PasswordAuthentication = false;
          #allowSFTP = false; # Don't set this if you need sftp
          challengeResponseAuthentication = false;
        };
        extraConfig = ''
          AllowTcpForwarding yes
          X11Forwarding yes
          AllowAgentForwarding yes
          AllowStreamLocalForwarding yes
          AuthenticationMethods publickey
          X11UseLocalhost no
          StreamLocalBindUnlink yes
        '';
      };
    })
  ];
}
