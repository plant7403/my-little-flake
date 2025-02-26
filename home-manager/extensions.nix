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
