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
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
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
      /*
        stylix.image = pkgs.fetchurl {
          url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
          sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
        };
      */

      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/outrun-dark.yaml";
      stylix.fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "Source Code Pro";
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
      stylix.opacity = {
        terminal = 0.5;
        applications = 0.75;
        desktop = 0.75;
        popups = 0.75;
      };
      stylix.autoEnable = true;
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
    })

    (mkIf cfg.isSteamDeck {
      services.xserver.displayManager.gdm.enable = mkForce false;
    })
  ];
}
