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
      dark = "dracula-icon-theme";
      package = pkgs.dracula-icon-theme;
    };
    cursor = {
      name = "Posy_Cursors";
      package = pkgs.posy-cursors;
      size = 1;
    };
    targets = {
      gtk = {
        enable = true;
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
