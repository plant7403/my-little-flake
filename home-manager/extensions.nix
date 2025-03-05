{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.grand-theft-focus
    gnomeExtensions.bing-wallpaper-changer
    gnomeExtensions.tiling-assistant
    gnomeExtensions.blur-my-shell
    gnomeExtensions.random-wallpaper
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.tailscale-qs
    gnomeExtensions.tailscale-status
    gnomeExtensions.gsconnect
    gnomeExtensions.syncthing-indicator
    gnomeExtensions.syncthing-toggle

    #gnomeExtensions.syncthing-indicator
    trayscale
    light
    emote
    gnome-tweaks

  ];
  ### SHORTCUTS
  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "caffeine@patapon.info"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "grand-theft-focus@zalckos.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "status-icons@gnome-shell-extensions.gcampax.github.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "tailscale@joaophi.github.com"
        "trayIconsReloaded@selfmade.pl"
        "gsconnect@andyholmes.github.io"
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
        "element-desktop.desktop"
      ];
      "extensions/blur-my-shell/applications/opacity" = 235;
      # "extensions/blur-my-shell/applications/blur" = true;
      "extensions/blur-my-shell/applications/sigma" = 30;
      "extensions/blur-my-shell/applications/enable-all" = true;
      "extensions/blur-my-shell/applications/dynamic-opacity" = false;
      "extensions/blur-my-shell/applications/brightness" = 1.0;

      "extensions/blur-my-shell/panel/static-blur" = false;
      "extensions/blur-my-shell/panel/sigma" = 1;
      "extensions/blur-my-shell/panel/brightness" = 1.0;
    };
    /*
      "org/gnome/desktop/interface" = {
         color-scheme = "prefer-dark";
         enable-hot-corners = true;
       };
       "org/gnome/desktop/wm/preferences" = {
         workspace-names = [ "Main" ];
       };
    */
  };

}
