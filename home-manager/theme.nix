{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    palenight-theme
    dracula-theme
  ];

  gtk = {
    enable = true;

    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };

    /*
         theme = lib.mkForce {
        name = "tokyonight";
        package = pkgs.tokyonight-gtk-theme;
      };
    */

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
  qt.platformTheme.name = lib.mkForce "adwaita";
  # home.sessionVariables.GTK_THEME = "tokyonight-gtk-theme";
}
