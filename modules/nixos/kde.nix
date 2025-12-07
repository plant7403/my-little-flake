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

    # Using Wayland (preferred)
    services.displayManager.sddm.settings.General.DisplayServer = "wayland";
    /*
         qt = {
        enable = true;
        platformTheme = "kde6";
        style = "adwaita-dark";
      };
    */
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
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
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    stylix.opacity = {
      terminal = 0.5;
      applications = 0.75;
      desktop = 0.75;
      popups = 0.75;
    };

    stylix.autoEnable = true;

    home-manager.users.egor = {
      programs.plasma = {
        enable = true;

        #
        # Some high-level settings:
        #

        /*
          workspace = {
            clickItemTo = "open"; # If you liked the click-to-open default from plasma 5
            lookAndFeel = "org.kde.breezedark.desktop";
            cursor = {
              theme = "Bibata-Modern-Ice";
              size = 32;
            };
            iconTheme = "Papirus-Dark";
            wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
          };
        */

        hotkeys.commands."launch-konsole" = {
          name = "Launch Konsole";
          key = "Meta+Alt+K";
          command = "konsole";
        };

        /*
             fonts = {
            general = {
              family = "JetBrains Mono";
              pointSize = 12;
            };
          };
        */

        desktop.widgets = [
          {
            plasmusicToolbar = {
              position = {
                horizontal = 51;
                vertical = 100;
              };
              size = {
                width = 250;
                height = 250;
              };
            };
          }
        ];

        panels = [
          # Windows-like panel at the bottom
          {
            location = "bottom";
            widgets = [
              # We can configure the widgets by adding the name and config
              # attributes. For example to add the the kickoff widget and set the
              # icon to "nix-snowflake-white" use the below configuration. This will
              # add the "icon" key to the "General" group for the widget in
              # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
              {
                name = "org.kde.plasma.kickoff";
                config = {
                  General = {
                    icon = "nix-snowflake-white";
                    alphaSort = true;
                  };
                };
              }
              # Or you can configure the widgets by adding the widget-specific options for it.
              # See modules/widgets for supported widgets and options for these widgets.
              # For example:
              {
                kickoff = {
                  sortAlphabetically = true;
                  icon = "nix-snowflake-white";
                };
              }
              # Adding configuration to the widgets can also for example be used to
              # pin apps to the task-manager, which this example illustrates by
              # pinning dolphin and konsole to the task-manager by default with widget-specific options.
              {
                iconTasks = {
                  launchers = [
                    "applications:org.kde.dolphin.desktop"
                    "applications:org.kde.konsole.desktop"
                  ];
                };
              }
              # Or you can do it manually, for example:
              {
                name = "org.kde.plasma.icontasks";
                config = {
                  General = {
                    launchers = [
                      "applications:org.kde.dolphin.desktop"
                      "applications:org.kde.konsole.desktop"
                    ];
                  };
                };
              }
              # If no configuration is needed, specifying only the name of the
              # widget will add them with the default configuration.
              "org.kde.plasma.marginsseparator"
              # If you need configuration for your widget, instead of specifying the
              # the keys and values directly using the config attribute as shown
              # above, plasma-manager also provides some higher-level interfaces for
              # configuring the widgets. See modules/widgets for supported widgets
              # and options for these widgets. The widgets below shows two examples
              # of usage, one where we add a digital clock, setting 12h time and
              # first day of the week to Sunday and another adding a systray with
              # some modifications in which entries to show.
              {
                digitalClock = {
                  calendar.firstDayOfWeek = "sunday";
                  time.format = "12h";
                };
              }
              {
                systemTray.items = {
                  # We explicitly show bluetooth and battery
                  shown = [
                    "org.kde.plasma.battery"
                    "org.kde.plasma.bluetooth"
                  ];
                  # And explicitly hide networkmanagement and volume
                  hidden = [
                    "org.kde.plasma.networkmanagement"
                    "org.kde.plasma.volume"
                  ];
                };
              }
            ];
            hiding = "autohide";
          }
          # Application name, Global menu and Song information and playback controls at the top
          {
            location = "top";
            height = 26;
            widgets = [
              {
                applicationTitleBar = {
                  behavior = {
                    activeTaskSource = "activeTask";
                  };
                  layout = {
                    elements = [ "windowTitle" ];
                    horizontalAlignment = "left";
                    showDisabledElements = "deactivated";
                    verticalAlignment = "center";
                  };
                  overrideForMaximized.enable = false;
                  titleReplacements = [
                    {
                      type = "regexp";
                      originalTitle = "^Brave Web Browser$";
                      newTitle = "Brave";
                    }
                    {
                      type = "regexp";
                      originalTitle = ''\\bDolphin\\b'';
                      newTitle = "File manager";
                    }
                  ];
                  windowTitle = {
                    font = {
                      bold = false;
                      fit = "fixedSize";
                      size = 12;
                    };
                    hideEmptyTitle = true;
                    margins = {
                      bottom = 0;
                      left = 10;
                      right = 5;
                      top = 0;
                    };
                    source = "appName";
                  };
                };
              }
              "org.kde.plasma.appmenu"
              "org.kde.plasma.panelspacer"
              {
                plasmusicToolbar = {
                  panelIcon = {
                    albumCover = {
                      useAsIcon = false;
                      radius = 8;
                    };
                    icon = "view-media-track";
                  };
                  playbackSource = "auto";
                  musicControls.showPlaybackControls = true;
                  songText = {
                    displayInSeparateLines = true;
                    maximumWidth = 640;
                    scrolling = {
                      behavior = "alwaysScroll";
                      speed = 3;
                    };
                  };
                };
              }
            ];
          }
        ];

        window-rules = [
          {
            description = "Dolphin";
            match = {
              window-class = {
                value = "dolphin";
                type = "substring";
              };
              window-types = [ "normal" ];
            };
            apply = {
              noborder = {
                value = true;
                apply = "force";
              };
              # `apply` defaults to "apply-initially"
              maximizehoriz = true;
              maximizevert = true;
            };
          }
        ];

        powerdevil = {
          AC = {
            powerButtonAction = "lockScreen";
            autoSuspend = {
              action = "shutDown";
              idleTimeout = 1000;
            };
            turnOffDisplay = {
              idleTimeout = 1000;
              idleTimeoutWhenLocked = "immediately";
            };
          };
          battery = {
            powerButtonAction = "sleep";
            whenSleepingEnter = "standbyThenHibernate";
          };
          lowBattery = {
            whenLaptopLidClosed = "hibernate";
          };
        };

        kwin = {
          edgeBarrier = 0; # Disables the edge-barriers introduced in plasma 6.1
          cornerBarrier = false;

          scripts.polonium.enable = true;
        };

        kscreenlocker = {
          lockOnResume = true;
          timeout = 10;
        };

        #
        # Some mid-level settings:
        #
        shortcuts = {
          ksmserver = {
            "Lock Session" = [
              "Screensaver"
              "Meta+Ctrl+Alt+L"
            ];
          };

          kwin = {
            "Expose" = "Meta+,";
            "Switch Window Down" = "Meta+J";
            "Switch Window Left" = "Meta+H";
            "Switch Window Right" = "Meta+L";
            "Switch Window Up" = "Meta+K";
          };
        };

        #
        # Some low-level settings:
        #
        configFile = {
          baloofilerc."Basic Settings"."Indexing-Enabled" = false;
          kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "SF";
          kwinrc.Desktops.Number = {
            value = 8;
            # Forces kde to not change this value (even through the settings app).
            immutable = true;
          };
          kscreenlockerrc = {
            Greeter.WallpaperPlugin = "org.kde.potd";
            # To use nested groups use / as a separator. In the below example,
            # Provider will be added to [Greeter][Wallpaper][org.kde.potd][General].
            "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
          };
        };
      };
    };
  };
}
