{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.grand-theft-focus

    gnomeExtensions.blur-my-shell

    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.tailscale-qs
    #gnomeExtensions.tailscale-status
    gnomeExtensions.gsconnect
    #gnomeExtensions.syncthing-indicator
    #gnomeExtensions.syncthing-toggle

    #gnomeExtensions.syncthing-indicator

    gnomeExtensions.clipqr
    gnomeExtensions.ddterm

    gnomeExtensions.duckduckbang
    gnomeExtensions.folder-search-provider
    gnomeExtensions.todo-list

    gnomeExtensions.paperwm
    gnomeExtensions.dash-to-dock
    gnomeExtensions.focus-follows-workspace
    gnomeExtensions.switcher
    #trayscale
    light
    emote
    gnome-tweaks
    gnomeExtensions.quick-settings-tweaker
    # gnomeExtensions.translate-indicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.firefox-profiles
    #gnomeExtensions.gestureImprovements
    gnomeExtensions.just-perfection
    gnomeExtensions.save-my-windows
    gnomeExtensions.window-commander
    ulauncher
    gnomeExtensions.tweaks-in-system-menu
    gnomeExtensions.systemd-manager

    dconf2nix
  ];

  services.polkit-gnome.enable = true;

 

  /*
    xdg.configFile."gtk-3.0/bookmarks".force = true;
    xdg.configFile."gtk-3.0/bookmarks".text = ''
      file:///home/egor/Documentos Documents
      ...
    '';
  */
  gtk.gtk3 = {
    bookmarks = [
      "file://${config.xdg.userDirs.download}"
      "file://${config.xdg.userDirs.documents}"
      "file://${config.home.homeDirectory}/.Secret"
      "file://${config.xdg.userDirs.music}"
      "file://${config.xdg.userDirs.pictures}"
      "file://${config.home.homeDirectory}/Sync"
      "file://${config.home.homeDirectory}/DCIM"
      "file://${config.home.homeDirectory}/Projects"
      "file://${config.home.homeDirectory}/Pak-Unity"
      #"file://${config.services.syncthing.settings.folders."sync".path}"
      #"file://${self}"
    ]; # TODO: NEED FIX; everything in english !!!
  };

  xdg.autostart = {
    enable = true;
    entries = [
      "${pkgs.element-desktop}/share/applications/element-desktop.desktop" # ${pkgs.element-desktop}/share/applications/
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };
  xdg.configFile."mimeapps.list".force = true;
}
