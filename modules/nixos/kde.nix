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
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "egor";
    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  };
}
