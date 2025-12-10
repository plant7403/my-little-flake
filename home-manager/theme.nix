{
  pkgs,
  lib,
  ...
}:
{
  stylix = {
    enable = true;
    icons = {
      enable = true;
      dark = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    cursor = {
      name = "Posy_Cursor";
      package = pkgs.posy-cursors;
      size = 1;
    };

    targets = {
      gtk = {
        enable = true;
        flatpakSupport.enable = true;
        extraCss = ''
          /*********************
          * Window Decorations *
          *********************/
          window {
            --wm-border-width: 3px;
            --wm-border-color: #6272a4;
            --wm-border-radius: 12px;
          }
          window.maximized {
            border: var(--wm-border-width) solid var(--wm-border-color);
            border-radius: var(--wm-border-radius);
          }
          window:not(.maximized) {
            border: none;
          }
          window.csd {
            margin: 0px;
            border-radius: var(--wm-border-radius);
            border: var(--wm-border-width) solid var(--wm-border-color);
          }
          window.csd.popup,
          window.csd.dialog.message {
            border-radius: 12px;
            border: 4px solid var(--wm-border-color);
          }
          window.solid-csd {
            margin: 0;
            padding: 4px;
            border-radius: var(--wm-border-radius);
            border: 4px solid var(--wm-border-color);
          }
          window.popup,
          window.ssd {
            border-radius: 12px;
            border: 4px solid var(--wm-border-color);
          }

        '';
        /*
          theme = lib.mkForce {
            name = "catppuchin";
            package = pkgs.catppuccin-gtk;
          };
        */
      };
      qt = {
        enable = true;
        platform = "qtct";
      };
    };
    opacity = {
      terminal = 0.5;
      applications = 0.75;
      desktop = 0.75;
      popups = 0.75;
    };
  };

  /*
    gtk = {
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

  #qt.enable = true;
  #qt.platformTheme = lib.mkForce "qtct";
  /*
    qt.style.name = "kvantum";

    home.packages = with pkgs; [

      (catppuccin-kvantum.override {
        accent = "Mauve";
        variant = "Mocha";
      })
    ];

    xdg.configFile."Kvantum/kvantum.kvconfig".source =
      (pkgs.formats.ini { }).generate "kvantum.kvconfig"
        {
          General.Theme = "Catppuccin-Mocha-Mauve";
        };
  */
}
