{
  pkgs,
  lib,
  config,
  outputs,
  ...
}:
with lib;
let
  cfg = config.modules.gnome;
in
{
  options.modules.gnome = {
    enable = mkEnableOption "service";
    autologin = mkOption {
      type = types.bool;
      default = false;
    };
    remote = mkOption {
      type = types.bool;
      default = false;
    };

    isSteamDeck = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.sushi.enable = true;

      environment.gnome.excludePackages = with pkgs; [
        #gnome-photos
        gnome-tour
        #gedit # text editor

        #cheese # webcam tool
        gnome-music

        epiphany # web browser
        geary # email reader
        gnome-characters
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-contacts
        gnome-initial-setup
      ];
      programs.dconf.enable = true;
      environment.systemPackages = with pkgs; [
        gnome-tweaks
        libsecret
        xorg.xprop
      ];
      services.udev.packages = [
        pkgs.gnome-settings-daemon
      ];
      # Configure keymap in X11
      services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
      };
      ### STYLIX

      stylix.enable = true;
      stylix.polarity = "dark";
      #stylix.image = /run/current-system/sw/share/backgrounds/gnome/vnc-d.png;
      stylix.image = pkgs.fetchurl {
        url = "https://4kwallpapers.com/images/wallpapers/frierens-staff-3840x2160-20067.jpg";
        sha256 = "0kcl0ssqfmd9vpjlhgb3kxxqdy29q5iy9bykz50m7k88749bbkpr";
      };
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/outrun-dark.yaml";
      stylix.fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "Noto Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "Noto Sans";
        };

        monospace = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
      /*
        stylix.opacity = {
             terminal = 0.5;
             applications = 0.75;
             desktop = 0.75;
             popups = 0.75;
           };
      */
      stylix.autoEnable = true;

      # !!! stylix.targets.librewolf.profileNames = [ "default" ];

      stylix.targets = {
        qt.platform = lib.mkForce "qtct";
        #librewolf.profileNames = ["default"];
      };

      home-manager.users.egor.programs.gnome-shell = {
        enable = true;
        extensions = [ { package = pkgs.gnomeExtensions.gsconnect; } ];
      };

      networking.firewall = rec {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };

      programs.seahorse.enable = true; # enable the graphical frontend

      security = {
        polkit.enable = true;
        /*
          pam.services = {

                 ssdm = {
                   enableGnomeKeyring = true;
                 };
                 hyprland = {
                   enableGnomeKeyring = true;
                 };
               };
        */
      };
      services.dbus.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.accounts-daemon.enable = true;

      services.dbus.packages = [
        pkgs.gnome-keyring
        pkgs.gcr
      ];
    })
    (mkIf cfg.autologin {
      # Enable automatic login for the user.

      services.displayManager.autoLogin.enable = true;
      services.displayManager.autoLogin.user = "egor";
      # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;
    })
    (mkIf cfg.remote {
      # minimized for clarity.
      # Some of these might not be needed. After some trial and error
      # I got this working with these configs.
      # I do not have the patience to rn an elimination test.

      services.gnome.gnome-remote-desktop.enable = true;

      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
      services.xrdp.openFirewall = true;

      environment.systemPackages = with pkgs; [
        gnome-session
      ];

      # Open ports in the firewall.
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 3389 ];
        allowedUDPPorts = [ 3389 ];
      };
      # new
      services.sysprof.enable = true;
      hardware.sensor.iio.enable = true;
    })

    (mkIf cfg.isSteamDeck {
      services.xserver.displayManager.gdm.enable = mkForce false;
    })
  ];
}
