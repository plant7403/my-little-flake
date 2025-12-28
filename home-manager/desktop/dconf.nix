# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "com/github/amezin/ddterm" = {
      background-opacity = 0.5;
      bold-is-bright = true;
      hide-animation-duration = 1.0e-3;
      hide-when-focus-lost = true;
      hide-window-on-esc = true;
      panel-icon-type = "none";
      pointer-autohide = false;
      scrollback-lines = 100000;
      show-animation-duration = 1.0e-3;
      tab-label-ellipsize-mode = "start";
      tab-label-width = 7.0e-2;
      window-maximize = false;
    };

    "org/gnome/Extensions" = {
      window-height = 1015;
    };

    "org/gnome/TextEditor" = {
      style-scheme = "stylix";
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [
        "System"
        "Utilities"
        "YaST"
        "Pardus"
      ];
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = [ "X-Pardus-Apps" ];
      name = "X-Pardus-Apps.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/System" = {
      apps = [
        "org.gnome.baobab.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.Logs.desktop"
        "org.gnome.Sysprof.desktop"
        "org.gnome.SystemMonitor.desktop"
        "org.gnome.tweaks.desktop"
      ];
      name = "X-GNOME-Shell-System.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [
        "org.gnome.Decibels.desktop"
        "org.gnome.Connections.desktop"
        "org.gnome.Papers.desktop"
        "org.gnome.font-viewer.desktop"
        "org.gnome.Loupe.desktop"
      ];
      name = "X-GNOME-Shell-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///nix/store/ryb7h281iyz59pjm884sg13xrnmjf44a-dimmed-background.png";
      picture-uri-dark = "file:///nix/store/ryb7h281iyz59pjm884sg13xrnmjf44a-dimmed-background.png";
    };

    "org/gnome/desktop/input-sources" = {
      mru-sources = [
        (mkTuple [
          "xkb"
          "us"
        ])
        (mkTuple [
          "xkb"
          "ru"
        ])
        (mkTuple [
          "xkb"
          "es"
        ])
      ];
      sources = [
        (mkTuple [
          "xkb"
          "us"
        ])
        (mkTuple [
          "xkb"
          "ru"
        ])
        (mkTuple [
          "xkb"
          "es"
        ])
      ];
      xkb-options = [ "ctrl:nocaps" ];
    };

    "org/gnome/desktop/interface" = {
      accent-color = "teal";
      color-scheme = "prefer-dark";
      cursor-size = 24;
      cursor-theme = "Posy_Cursor";
      document-font-name = "Adwaita Mono  11";
      enable-animations = true;
      font-name = "Adwaita Mono 12";
      gtk-theme = "adw-gtk3";
      icon-theme = "rose-pine-dawn";
      monospace-font-name = "Adwaita Mono 12";
    };

    "org/gnome/desktop/notifications" = {
      application-children = [
        "librewolf"
        "gnome-about-panel"
        "element-desktop"
        "org-keepassxc-keepassxc"
      ];
    };

    "org/gnome/desktop/notifications/application/element-desktop" = {
      application-id = "element-desktop.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-about-panel" = {
      application-id = "gnome-about-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/librewolf" = {
      application-id = "librewolf.desktop";
    };

    "org/gnome/desktop/notifications/application/org-keepassxc-keepassxc" = {
      application-id = "org.keepassxc.KeePassXC.desktop";
    };

    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ ];
      move-to-monitor-down = [ ];
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      move-to-monitor-up = [ ];
      move-to-workspace-down = [ ];
      move-to-workspace-left = [ ];
      move-to-workspace-right = [ ];
      move-to-workspace-up = [ ];
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-group = [ ];
      switch-group-backward = [ ];
      switch-panels = [ ];
      switch-panels-backward = [ ];
      switch-to-workspace-1 = [ ];
      switch-to-workspace-last = [ ];
      switch-to-workspace-left = [ ];
      switch-to-workspace-right = [ ];
      unmaximize = [ ];
    };

    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [
        "Workspace 1"
        "Workspace 2"
        "Workspace 3"
        "Workspace 4"
      ];
    };

    "org/gnome/eog/view" = {
      background-color = "#241b26";
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/gnome-system-monitor" = {
      maximized = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-height = 1015;
      window-width = 800;
    };

    "org/gnome/gnome-system-monitor/proctree" = {
      col-26-visible = false;
      col-26-width = 0;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = false;
      auto-maximize = true;
      edge-tiling = true;
      experimental-features = [ "variable-refresh-rate" ];
      workspaces-only-on-primary = false;
    };

    "org/gnome/mutter/keybindings" = {
      cancel-input-capture = [ ];
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };

    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = [ ];
    };

    "org/gnome/nautilus/preferences" = {
      migrated-gtk-settings = true;
    };

    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-last-shown = mkInt64 1766926461863495;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
      rotate-video-lock-static = [ ];
      www = [ "<Shift><Control>s" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = [ "<Shift><Control>u" ];
      command = "ulauncher";
      name = "ulauncher";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = [ "<Shift><super>t" ];
      command = "ghostty";
      name = "ghostty";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [
        "tweaks-system-menu@extensions.gnome-shell.fifi.org"
        "systemd-manager@hardpixel.eu"
        "just-perfection-desktop@just-perfection"
      ];
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "caffeine@patapon.info"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "status-icons@gnome-shell-extensions.gcampax.github.com"
        "tailscale@joaophi.github.com"
        "trayIconsReloaded@selfmade.pl"
        "gsconnect@andyholmes.github.io"
        "Vitals@CoreCoding.com"
        "clipqr@drien.com"
        "ddterm@amezin.github.com"
        "todoit@wassimbj.github.io"
        "paperwm@paperwm.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "clipboard-indicator@tudmotu.com"
        "switcher@landau.fi"
        "window-commander@gnikolaos.gr"
        "gsconnect@andyholmes.github.io"
      ];
      favorite-apps = [
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
      welcome-dialog-last-shown-version = "49.2";
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-brightness = 0.0;
      icon-contrast = 0.0;
      icon-opacity = 240;
      icon-saturation = 0.0;
      icon-size = 0;
      legacy-tray-enabled = true;
      tray-pos = "center";
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      settings-version = 2;
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness = 0.6;
      sigma = 30;
      style-dialogs = 2;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blacklist = [
        "Plank"
        "com.desktop.ding"
        "Conky"
        "com.github.amezin.ddterm"
      ];
      blur = true;
      brightness = 1.0;
      dynamic-opacity = true;
      enable-all = true;
      opacity = 240;
      sigma = 0;
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      brightness = 0.6;
      sigma = 30;
      static-blur = true;
      style-dash-to-dock = 0;
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      style-components = 3;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      brightness = 1.0;
      sigma = 5;
      static-blur = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/extensions/caffeine" = {
      indicator-position-max = 4;
      user-enabled = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dash-max-icon-size = 64;
      intellihide-mode = "ALL_WINDOWS";
      show-trash = false;
    };

    "org/gnome/shell/extensions/duckduckbang" = {
      search-engine = 7;
    };

    "org/gnome/shell/extensions/gsconnect" = {
      name = "stellar";
    };

    "org/gnome/shell/extensions/paperwm" = {
      horizontal-margin = 5;
      last-used-display-server = "Wayland";
      restore-attach-modal-dialogs = "true";
      restore-edge-tiling = "true";
      restore-keybinds = ''
        {"toggle-tiled-left":{"bind":"[\\"<Super>Left\\"]","schema_id":"org.gnome.mutter.keybindings"},"toggle-tiled-right":{"bind":"[\\"<Super>Right\\"]","schema_id":"org.gnome.mutter.keybindings"},"cancel-input-capture":{"bind":"[\\"<Super><Shift>Escape\\"]","schema_id":"org.gnome.mutter.keybindings"},"restore-shortcuts":{"bind":"[\\"<Super>Escape\\"]","schema_id":"org.gnome.mutter.wayland.keybindings"},"switch-to-workspace-last":{"bind":"[\\"<Super>End\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-panels":{"bind":"[\\"<Control><Alt>Tab\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-group-backward":{"bind":"[\\"<Shift><Super>Above_Tab\\",\\"<Shift><Alt>Above_Tab\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"unmaximize":{"bind":"[\\"<Super>Down\\",\\"<Alt>F5\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-to-workspace-1":{"bind":"[\\"<Super>Home\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-monitor-left":{"bind":"[\\"<Super><Shift>Left\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-monitor-down":{"bind":"[\\"<Super><Shift>Down\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-to-workspace-left":{"bind":"[\\"<Super>Page_Up\\",\\"<Super>KP_Prior\\",\\"<Super><Alt>Left\\",\\"<Control><Alt>Left\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-group":{"bind":"[\\"<Super>Above_Tab\\",\\"<Alt>Above_Tab\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-workspace-left":{"bind":"[\\"<Super><Shift>Page_Up\\",\\"<Super><Shift>KP_Prior\\",\\"<Super><Shift><Alt>Left\\",\\"<Control><Shift><Alt>Left\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-workspace-right":{"bind":"[\\"<Super><Shift>Page_Down\\",\\"<Super><Shift>KP_Next\\",\\"<Super><Shift><Alt>Right\\",\\"<Control><Shift><Alt>Right\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-panels-backward":{"bind":"[\\"<Shift><Control><Alt>Tab\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-workspace-up":{"bind":"[\\"<Control><Shift><Alt>Up\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-to-workspace-right":{"bind":"[\\"<Super>Page_Down\\",\\"<Super>KP_Next\\",\\"<Super><Alt>Right\\",\\"<Control><Alt>Right\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-workspace-down":{"bind":"[\\"<Control><Shift><Alt>Down\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-applications":{"bind":"[\\"<Super>Tab\\",\\"<Alt>Tab\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"maximize":{"bind":"[\\"<Super>Up\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-monitor-right":{"bind":"[\\"<Super><Shift>Right\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-applications-backward":{"bind":"[\\"<Shift><Super>Tab\\",\\"<Shift><Alt>Tab\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-monitor-up":{"bind":"[\\"<Super><Shift>Up\\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"shift-overview-up":{"bind":"[\\"<Super><Alt>Up\\"]","schema_id":"org.gnome.shell.keybindings"},"shift-overview-down":{"bind":"[\\"<Super><Alt>Down\\"]","schema_id":"org.gnome.shell.keybindings"},"focus-active-notification":{"bind":"[\\"<Super>n\\"]","schema_id":"org.gnome.shell.keybindings"},"toggle-message-tray":{"bind":"[\\"<Super>v\\",\\"<Super>m\\"]","schema_id":"org.gnome.shell.keybindings"},"rotate-video-lock-static":{"bind":"[\\"<Super>o\\",\\"XF86RotationLockToggle\\"]","schema_id":"org.gnome.settings-daemon.plugins.media-keys"}}
      '';
      restore-workspaces-only-on-primary = "true";
      selection-border-radius-bottom = 10;
      selection-border-radius-top = 10;
      selection-border-size = 5;
      show-workspace-indicator = false;
      vertical-margin = 10;
      window-gap = 10;
    };

    "org/gnome/shell/extensions/paperwm/workspaces" = {
      list = [
        "8ee7a3f5-9c8f-41c6-9fbb-9460e90b3d5e"
        "fb33d93a-7612-4232-a046-746b35b41117"
        "2d7ba989-0bd9-4803-8622-443bed51ef7d"
        "789674cc-6a27-4fad-9e11-db39432da315"
      ];
    };

    "org/gnome/shell/extensions/paperwm/workspaces/2d7ba989-0bd9-4803-8622-443bed51ef7d" = {
      index = 2;
    };

    "org/gnome/shell/extensions/paperwm/workspaces/789674cc-6a27-4fad-9e11-db39432da315" = {
      index = 3;
    };

    "org/gnome/shell/extensions/paperwm/workspaces/8ee7a3f5-9c8f-41c6-9fbb-9460e90b3d5e" = {
      index = 0;
    };

    "org/gnome/shell/extensions/paperwm/workspaces/fb33d93a-7612-4232-a046-746b35b41117" = {
      index = 1;
    };

    "org/gnome/shell/extensions/trayIconsReloaded" = {
      applications = "[{\"id\":\"Grayjay.desktop\",\"hidden\":false}]";
      invoke-to-workspace = true;
      tray-position = "center";
      wine-behavior = true;
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Stylix";
    };

    "org/gnome/shell/extensions/vitals" = {
      fixed-widths = true;
      hide-zeros = false;
      hot-sensors = [
        "_memory_usage_"
        "_processor_usage_"
        "__network-rx_max__"
        "__network-tx_max__"
        "_network_public_ip_"
        "_storage_free_"
      ];
      icon-style = 1;
      include-static-info = false;
      menu-centered = false;
      position-in-panel = 0;
      use-higher-precision = false;
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ ];
      shift-overview-down = [ ];
      shift-overview-up = [ ];
      toggle-message-tray = [ ];
    };

    "org/gnome/shell/world-clocks" = {
      locations = [ ];
    };

  };
}
