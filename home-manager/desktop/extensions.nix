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

  ### SHORTCUTS
  dconf.settings = {
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
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
      #search = [ "<Control><super>space" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      "binding" = [ "<Shift><Control>u" ];
      "command" = "ulauncher";
      "name" = "ulauncher";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      "binding" = [ "<Shift><super>t" ];
      "command" = "ghostty";
      "name" = "ghostty";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      "www" = [ "<Shift><Control>s" ];
    };

    "org/gnome/mutter" = {
      "edge-tiling" = true;
      experimental-features = [
        #"scale-monitor-framebuffer" # Enables fractional scaling (125% 150% 175%)
        "variable-refresh-rate" # Enables Variable Refresh Rate (VRR) on compatible displays
        #"xwayland-native-scaling" # Scales Xwayland applications to look crisp on HiDPI screens
      ];
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
        #"grand-theft-focus@zalckos.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "status-icons@gnome-shell-extensions.gcampax.github.com"
        #"system-monitor@gnome-shell-extensions.gcampax.github.com"
        "tailscale@joaophi.github.com"
        "trayIconsReloaded@selfmade.pl"
        "gsconnect@andyholmes.github.io"
        "Vitals@CoreCoding.com"

        "clipqr@drien.com"
        "ddterm@amezin.github.com"
        #"duckduckbang@merijn"
        #"folder-search-provider@sitnik.ru"
        "todoit@wassimbj.github.io"
        "paperwm@paperwm.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "clipboard-indicator@tudmotu.com"
        #"focus-follows-workspace@christopher.luebbemeier.gmail.com"
        "switcher@landau.fi"

        "window-commander@gnikolaos.gr"
        "tweaks-system-menu@extensions.gnome-shell.fifi.org"
        "systemd-manager@hardpixel.eu"
        #"save-my-windows@lukastymo.com"
        #"just-perfection-desktop@just-perfection"
      ];

      favorite-apps = [
        #"org.gnome.Console.desktop"
        "com.mitchellh.ghostty.desktop"
        "org.gnome.Nautilus.desktop"
        "librewolf.desktop"
        "chromium-browser.desktop"
        "codium.desktop"
        "element-desktop.desktop"
        "signal.desktop"
        "obsidian.desktop"
        "org.keepassxc.KeePassXC.desktop"
      ];
      "extensions/blur-my-shell/applications/opacity" = 240;
      #"extensions/blur-my-shell/applications/blur" = true;
      "extensions/blur-my-shell/applications/sigma" = 0;
      "extensions/blur-my-shell/applications/enable-all" = true;
      "extensions/blur-my-shell/applications/dynamic-opacity" = true;
      "extensions/blur-my-shell/applications/brightness" = 1.0;
      "extensions/blur-my-shell/appfolder/style-dialogs" = 2;
      "extensions/blur-my-shell/panel/static-blur" = false;
      "extensions/blur-my-shell/panel/sigma" = 5;
      "extensions/blur-my-shell/panel/brightness" = 1.0;
      "extensions/blur-my-shell/overview/style-components" = 3;

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
      "extensions/dash-to-dock/intellihide-mode" = "ALL_WINDOWS";
    };
    extensions/vitals/hot-sensors
  ['_memory_usage_', '__network-rx_max__', '_network_public_ip_', '__network-tx_max__', '_storage_free_', '_processor_usage_']
    /*
      "org/gnome/desktop/interface" = {
         color-scheme = "prefer-dark";
         enable-hot-corners = true;
       };
       "org/gnome/desktop/wm/preferences" = {
         workspace-names = [ "Main" ];
       };
    */
    "com/github/amezin/ddterm" = {
      panel-icon-type = "none";
      background-opacity = "0.5";
      hide-when-focus-lost = true;
      hide-window-on-esc = true;
      tab-label-ellipsize-mode = "start";
    };
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
