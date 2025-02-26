{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.kde;
in
{
  options.modules.kde = {
    enable = mkEnableOption "service";
    /*
      kde = mkOption {
        type = types.str;
        default = "default";
      };
    */

  };

  config = mkIf cfg.enable {
    services.xserver.enable = true; # optional
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    # xdg.portal.enable = true;
    # Using Wayland (preferred)
    services.displayManager.sddm.settings.General.DisplayServer = "wayland";

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      elisa
    ];

    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "egor";
    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    /*
      systemd.services."getty@tty1".enable = false;
       systemd.services."autovt@tty1".enable = false;
    */
    # Technically not related to this issue, but still useful
    xdg.configFile."menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    qt = {
      enable = true;
      platformTheme.package = with pkgs.kdePackages; [
        plasma-integration
        # I don't remember why I put this is here, maybe it fixes the theme of the system setttings
        systemsettings
      ];
      style = {
        package = pkgs.kdePackages.breeze;
        name = "Breeze";
      };
    };
    systemd.egor.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "kde";
    };
  };
}
