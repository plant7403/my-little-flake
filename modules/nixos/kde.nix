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
    # services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    # services.desktopManager.plasma6.enable = true;
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
    /*
      xdg.configFile."menus/applications.menu".source =
         "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    */
    /*
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
    */
    /*
      systemd.user.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "kde";
      };
    */
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

  };

}
