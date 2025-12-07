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
    gnomeExtensions.translate-indicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.firefox-profiles

    dconf2nix
  ];
  ### SHORTCUTS
  dconf.settings = {
    # ...
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "us"
        ])
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "ru"
        ])
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "es"
        ])
      ];
    };

    "org/gnome/mutter" = {
      "edge-tiling" = true;
    };
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
        #"system-monitor@gnome-shell-extensions.gcampax.github.com"
        "tailscale@joaophi.github.com"
        "trayIconsReloaded@selfmade.pl"
        "gsconnect@andyholmes.github.io"
        "Vitals@CoreCoding.com"

        "clipqr@drien.com"
        "ddterm@amezin.github.com"
        "duckduckbang@merijn"
        "folder-search-provider@sitnik.ru"
        "todoit@wassimbj.github.io"
        "paperwm@paperwm.github.com"
        "dash-to-dock@micxgx.gmail.com"
      ];

      favorite-apps = [
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "librewolf.desktop"
        "chromium-browser.desktop"
        "codium.desktop"
        "element-desktop.desktop"
        "signal.desktop"
        "obsidian.desktop"
        "com.bitwig.BitwigStudio.desktop"
        "com.github.flxzt.rnote.desktop"
        "org.keepassxc.KeePassXC.desktop"
      ];
      "extensions/blur-my-shell/applications/opacity" = 180;
      # "extensions/blur-my-shell/applications/blur" = true;
      "extensions/blur-my-shell/applications/sigma" = 15;
      "extensions/blur-my-shell/applications/enable-all" = true;
      "extensions/blur-my-shell/applications/dynamic-opacity" = true;
      "extensions/blur-my-shell/applications/brightness" = 1.0;
      "extensions/blur-my-shell/appfolder/style-dialogs" = 2;
      "extensions/blur-my-shell/panel/static-blur" = false;
      "extensions/blur-my-shell/panel/sigma" = 1;
      "extensions/blur-my-shell/panel/brightness" = 1.0;
      "extensions/blur-my-shell/overview/style-components" = 3;

      "com/github/amezin/ddterm/panel-icon-type" = "none";
      "com/github/amezin/ddterm/background-opacity" = 0.5;
      "com/github/amezin/ddterm/hide-when-focus-lost" = true;

      "com/github/amezin/ddterm/hide-window-on-esc" = true;

      "com/github/amezin/ddterm/tab-label-ellipsize-mode" = "start";

      "extensions/duckduckbang/search-engine" = 7;
      "extensions/paperwm/show-workspace-indicator" = false;
      "extensions/paperwm/selection-border-size" = 5;
      "extensions/paperwm/selection-border-radius-top" = 10;
      "extensions/paperwm/selection-border-radius-bottom" = 10;
      "extensions/paperwm/window-gap" = 10;
      "extensions/paperwm/vertical-margin" = 10;
      "extensions/paperwm/horizontal-margin" = 5;

      "extensions/appindicator/tray-pos" = "center";

      "extensions/dash-to-dock/show-trash" = false;
      "extensions/dash-to-dock/dash-max-icon-size" = 64;

      "extensions/blur-my-shell/applications/blur" = true;
      "extensions/blur-my-shell/applications/blacklist" = [
        "Plank"
        "com.desktop.ding"
        "Conky"
        "com.github.amezin.ddterm"
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
    entries = [
      "${pkgs.element-desktop}/share/applications/element-desktop.desktop"
    ];
  };

  xdg.mimeApps = {
    enable = false;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };
}
