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

      nix.daemonCPUSchedPolicy = "idle";
      nix.daemonIOSchedClass = "idle";
      systemd.services.nix-daemon.serviceConfig = {
        Nice = lib.mkForce 15;
        IOSchedulingClass = lib.mkForce "idle";
        IOSchedulingPriority = lib.mkForce 7;
      };

      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.sushi.enable = true;

      services.gnome.core-apps.enable = true;
      services.gnome.core-developer-tools.enable = true;
      services.gnome.games.enable = false;

      environment.gnome.excludePackages = with pkgs; [
        #gnome-photos
        gnome-tour
        #gedit # text editor

        #cheese # webcam tool
        gnome-music

        epiphany # web browser
        geary # email reader
        gnome-characters
        yelp # Help view
        gnome-contacts
        gnome-initial-setup
        gnome-terminal
        gnome-console
      ];

      programs.dconf.enable = true;
      environment.systemPackages = with pkgs; [
        gnome-tweaks
        libsecret
        xorg.xprop
        gdm-settings
        snoop
        #ghostty
        refine
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

      stylix = {
        ### STYLIX

        enable = true;
        autoEnable = true;

        homeManagerIntegration = {
          followSystem = true;
          autoImport = true;
        };

        polarity = "dark";
        targets = {
          gnome.enable = true;
          gtk = {
            enable = true;
          };
          qt = {
            enable = true;
            platform = lib.mkForce "qtct";
          };
        };

        #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/darkviolet.yaml";
        base16Scheme = {
          slug = "metheme";
          scheme = "Theme by me";
          author = "me";
          base00 = "241b26";
          base01 = "2f2a3f";
          base02 = "46354a";
          base03 = "89787f";
          base04 = "100712";
          base05 = "eed5d9";
          base06 = "d9c2c6";
          base07 = "e4ccd0";
          base08 = "877bb6";
          base09 = "de5b44";
          base0A = "a84a73";
          base0B = "c965bf";
          base0C = "9c5fce";
          base0D = "6a9eb5";
          base0E = "78a38f";
          base0F = "9e5769";
        };
        fonts = {
          sansSerif = {
            package = pkgs.nerd-fonts.adwaita-mono;
            name = "Adwaita Mono";
          };
          serif = {
            package = pkgs.nerd-fonts.adwaita-mono;
            name = "Adwaita Mono";
          };
          monospace = {
            package = pkgs.nerd-fonts.adwaita-mono;
            name = "Adwaita Mono";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };

        icons = {
          enable = true;
          dark = "rose-pine-dawn";
          light = "rose-pine-moon";
          package = pkgs.rose-pine-icon-theme;
        };
        cursor = {
          name = "Posy_Cursor";
          package = pkgs.posy-cursors;
          size = 24;
        };

        opacity = {
          terminal = 0.5;
          applications = 0.75;
          desktop = 0.75;
          popups = 0.75;
        };

      };

      programs.kdeconnect = {
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
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
        rtkit.enable = true;
        polkit = {
          enable = true;
          extraConfig = ''
            polkit.addRule(function(action, subject) {
              if ( subject.isInGroup("users") && (
               action.id == "org.freedesktop.login1.reboot" ||
               action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
               action.id == "org.freedesktop.login1.power-off" ||
               action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              ))
              { return polkit.Result.YES; }
            })
          '';
        };
      };
      security.pam.services.login.enableGnomeKeyring = true;
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
    })

    (mkIf cfg.isSteamDeck {
      services.xserver.displayManager.gdm.enable = mkForce false;
    })
  ];
}
