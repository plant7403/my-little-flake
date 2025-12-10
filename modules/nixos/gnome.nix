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

  inputImage = pkgs.fetchurl {
    url = "https://images.alphacoders.com/131/thumb-1920-1311951.jpg";
    sha256 = "sha256-Rb2zcFSO0Gk+TBEjD1X619+RxDCBalPhURYlVTHDf1s=";
  };
  brightness = "-30";
  contrast = "0";
  fillColor = "black";
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
        gnome-terminal
        #gnome-console
      ];
      programs.dconf.enable = true;
      environment.systemPackages = with pkgs; [
        gnome-tweaks
        libsecret
        xorg.xprop
        gdm-settings
        snoop
        #ghostty
      ];
      services.udev.packages = [
        pkgs.gnome-settings-daemon
      ];
      services.sysprof.enable = true;
      hardware.sensor.iio.enable = true;
      # Configure keymap in X11
      services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
      };
      ### STYLIX

      stylix.enable = true;
      stylix.autoEnable = true;

      stylix.polarity = "dark";
      #stylix.accentColor = "purple";
      stylix.targets = {
        gnome.enable = true;
        gtk.enable = true;
        qt = {
          enable = true;
          platform = lib.mkForce "qtct";
        };
      };
      #stylix.image = /run/current-system/sw/share/backgrounds/gnome/vnc-d.png;
      stylix.image = pkgs.runCommand "dimmed-background.png" { } ''
        ${lib.getExe' pkgs.imagemagick "convert"} "${inputImage}" -brightness-contrast ${brightness},${contrast} -fill ${fillColor} $out
      '';
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/darkviolet.yaml";
      stylix.fonts = {
        serif = {
          package = pkgs.liberation_ttf;
          name = "Liberation Sans";
        };
        /*
                sansSerif = {
                  package = pkgs.liberation_ttf;
                  name = "Agave";
                };
        */

        monospace = {
          package = pkgs.nerd-fonts.liberation;
          name = "Liberation Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };

      /*
        home-manager.users.egor.programs.gnome-shell = {
          enable = true;
          extensions = [ { package = pkgs.gnomeExtensions.gsconnect; } ];
        };
      */

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
