{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  /*
    !!!
    https://wiki.nixos.org/wiki/Cheatsheet
    !!!
  */
  stylix.targets.librewolf = {
    enable = true;
    colorTheme.enable = true;
    firefoxGnomeTheme.enable = true;
    profileNames = [ "default" ];
  }; # !!! remove it from here !!!

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common = {
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
    };
  };
  programs.librewolf = {
    enable = true;
    languagePacks = [
      "es-ES"
      "en-US"
    ];
    nativeMessagingHosts =
      with pkgs;
      with inputs.firefox-addons.packages.${pkgs.system};
      [
        keepassxc-browser
      ];
    profiles.default = lib.mkForce {
      settings = {
        "extensions.autoDisableScopes" = 0;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;

        "privacy.clearOnShutdown_v2.cache" = 0;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = 0;
        "extensions.activeThemeID" = "coffee_theme_firefox";
        "browser.theme.toolbar-theme" = 0;
        "privacy.resistFingerprinting.letterboxing" = false;
        "middlemouse.paste" = false;
        "browser.uiCustomization.state" = builtins.toJSON {
          currentVersion = 20;
          newElementCount = 23;
          dirtyAreaCache = [
            "nav-bar"
            "unified-extensions-area"
            "PersonalToolbar"
            "TabsToolbar"
            "widget-overflow-fixed-list"
            "toolbar-menubar"
          ];
          seen = [
            "developer-button"
            "_0050e3fa-15cc-4fb6-9c73-7354489a810b_-browser-action"
            "ublock0_raymondhill_net-browser-action"
            "_a138007c-5ff6-4d10-83d9-0afaf0efbe5e_-browser-action"
          ];
          placements = {
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "urlbar-container"
              "unified-extensions-button"
              "fxa-toolbar-menu-button"
            ];
            PersonalToolbar = [ "personal-bookmarks" ];
            TabsToolbar = [
              "tabbrowser-tabs"
              "alltabs-button"
            ];
            toolbar-menubar = [ "menubar-items" ];
            unified-extensions-area = [
              "ublock0_raymondhill_net-browser-action"
              "_0050e3fa-15cc-4fb6-9c73-7354489a810b_-browser-action"
              "_a138007c-5ff6-4d10-83d9-0afaf0efbe5e_-browser-action"
            ];
            widget-overflow-fixed-list = [
              "downloads-button"
              "developer-button"
              "firefox-view-button"
              "characterencoding-button"
            ];
          };
        };
      };
      userChrome = ''
        /* Hide tab bar in FF Quantum */
        @-moz-document url(chrome://browser/content/browser.xul), url(chrome://browser/content/browser.xhtml) {
          #TabsToolbar {
            visibility: collapse !important;
            margin-bottom: 21px !important;
          }

          #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
            visibility: collapse !important;
          }
        }
      '';
      userContent = ''
        /* Hide scrollbar in FF Quantum */
        *{scrollbar-width:none !important}
      '';
      containersForce = true;
      extensions = {
        force = true;
        packages =
          with pkgs;
          with inputs.firefox-addons.packages.${pkgs.system};
          [
            darkreader
            ublock-origin
            libredirect
            keepassxc-browser
          ];
        settings = {
          "uBlock0@raymondhill.net".settings = {
            force = true;
            privateAllowed = true;
            settings = {
              selectedFilterLists = [
                "user-filters"
                "ublock-filters"
                "ublock-badware"
                "ublock-privacy"
                "ublock-unbreak"
                "ublock-quick-fixes"
                "easylist"
                "easyprivacy"
                "urlhaus-1"
                "plowe-0"
              ];
            };
            permissions = [
              "alarms"
              "dns"
              "menus"
              "privacy"
              "storage"
              "tabs"
              "unlimitedStorage"
              "webNavigation"
              "webRequest"
              "webRequestBlocking"
              "<all_urls>"
              "http://*/*"
              "https://*/*"
              "file://*/*"
              "https://easylist.to/*"
              "https://*.fanboy.co.nz/*"
              "https://filterlists.com/*"
              "https://forums.lanik.us/*"
              "https://github.com/*"
              "https://*.github.io/*"
              "https://github.com/uBlockOrigin/*"
              "https://ublockorigin.github.io/*"
              "https://*.reddit.com/r/uBlockOrigin/*"
            ];

          };
        };
      };
      search = {
        force = true;
        default = "Startpage";
        privateDefault = "Startpage";
        order = [ "Startpage" ];
        engines = {
          "Startpage" = {
            urls = [ { template = "https://www.startpage.com/rvd/search?query={searchTerms}&language=auto"; } ];
            icon = "https://www.startpage.com/sp/cdn/favicons/mobile/android-icon-192x192.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@s" ];
          };
          nix-packages = {
            name = "Nix Packages";
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            definedAliases = [ "@nw" ];
          };

          home-manager = {
            name = "Home-Manager";
            urls = [
              { template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }
            ];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            definedAliases = [ "@hm" ];
          };

          nixpkgs-issues = {
            name = "nixpkgs-issues";
            urls = [
              {
                template = "https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue%20state%3Aopen%20{searchTerms}";
              }
            ];
            iconMapObj."16" = "https://github.com/favicon.ico";
            definedAliases = [ "@ni" ];
          };

          sourcegraph = {
            name = "sourcegraph";
            urls = [
              {
                template = "https://sourcegraph.com/search?q=context:global+file:%5C.nix+{searchTerms}&patternType=keyword&sm=0";
              }
            ];
            iconMapObj."16" = "https://sourcegraph.com/favicon.ico";
            definedAliases = [ "@sg" ];
          };

          bing.metaData.hidden = true;
          google.metaData.alias = "@g";
        };
      };
      bookmarks = [
        {
          name = "Nix sites";
          #force = true;
          toolbar = true;
          bookmarks = [
            {
              name = "homepage";
              url = "https://nixos.org/";
            }
            {
              name = "wiki";
              tags = [
                "wiki"
                "nix"
              ];
              url = "https://wiki.nixos.org/";
            }
            {
              name = "search";
              tags = [
                "search"
                "nix"
              ];
              url = "https://search.nixos.org/";
            }
            {
              name = "cheatsheet";
              tags = [
                "search"
                "nix"
              ];
              url = "https://wiki.nixos.org/wiki/Cheatsheet";
            }
          ];
        }
        {
          name = "Pak Unity";
          toolbar = true;
          bookmarks = [
            {
              name = "pak academy";
              url = "https://pak.academy/";
            }
            {
              name = "expat food";
              url = "https://expat.food/";
            }
          ];
        }
      ];

    };
  };
}







      pref("font.size.variable.x-western",20);
      pref("browser.toolbars.bookmarks.visibility","always");
      pref("privacy.resisttFingerprinting.letterboxing", true);
      pref("network.http.referer.XOriginPolicy",2);
      pref("privacy.clearOnShutdown.history",true);
      pref("privacy.clearOnShutdown.downloads",true);
      pref("privacy.clearOnShutdown.cookies",true);
      pref("gfx.webrender.software.opengl",false);
      pref("webgl.disabled",true);