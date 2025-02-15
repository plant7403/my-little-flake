{ pkgs, ... }: {
  /*
         gtk = {
        enable = true;

        iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
        };

        #theme = {
        #  name = "Dracula";
        #  package = pkgs.dracula-theme;
        # };

        cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
        };

        gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
        };

        gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
        };
        };
      */
  #systemd.user.sessionVariables = config.home-manager.users.egor.home.sessionVariables;

  #qt = {
  #  enable = true;
  #  platformTheme.name = "Dracula";
  #  style.name = "Dracula";
  #};

  #home.sessionVariables.GTK_THEME = "Dracula";
  # ...

  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"
        "Vitals@CoreCoding.com"
        "caffeine@patapon.info"
        #"tailscale-status@maxgallup.github.com"
        "tailscale@joaophi.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"

      ];

      favorite-apps = [
        "org.gnome.Console.desktop"
        "librewolf.desktop"
        "codium.desktop"
        "org.gnome.Nautilus.desktop"
        "bitwarden.desktop"
        #"logseq.desktop"
        "com.github.iwalton3.jellyfin-media-player.desktop"
        "virtualbox.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [ "Main" ];
    };
    #"org/gnome/desktop/background" = {
    #  picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-l.png";
    #  picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
    #};
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
      primary-color = "#3465a4";
      secondary-color = "#000000";
    };
    #"org/gnome/shell/extensions/user-theme" = {
    #  name = "Dracula";
    #};
  };

  stylix.enable = true;
  stylix.polarity = "dark";
  #stylix.image = /run/current-system/sw/share/backgrounds/gnome/vnc-d.png;
  stylix.image = pkgs.fetchurl {
    url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-dracula.png?raw=true";
    sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
  };
  /* stylix.image = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  }; */

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-city-dark.yaml";
  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
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
}
