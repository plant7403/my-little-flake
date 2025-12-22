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

  programs.librewolf = {
    enable = true;
    languagePacks = [
      "es-ES"
      "en-US"
    ];
    profiles.default = lib.mkForce {
      settings = {
        "extensions.autoDisableScopes" = 0;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;
      };
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
          name = "Nix sites";
          #force = true;
          toolbar = true;
          bookmarks = [
            {} ];
      ];

    };
    /*
      profiles.TEST = {
         id = 1;
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
             # Example with uBlock origin's extensionID
             "uBlock0@raymondhill.net".settings = {
               selectedFilterLists = [
                 "ublock-filters"
                 "ublock-badware"
                 "ublock-privacy"
                 "ublock-unbreak"
                 "ublock-quick-fixes"
               ];
             };

             # Example with Stylus' UUID-form extensionID
             "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
               dbInChromeStorage = true; # required for Stylus
             };
           };

         };
         search = {
           force = true;
           engines = {
             search = {
               force = true;
               default = "Startpage";
               engines = {
                 "Startpage" = {
                   urls = [ { template = "https://www.startpage.com/rvd/search?query={searchTerms}&language=auto"; } ];
                   iconUpdateURL = "https://www.startpage.com/sp/cdn/favicons/mobile/android-icon-192x192.png";
                   updateInterval = 24 * 60 * 60 * 1000; # every day
                   definedAliases = [ "@s" ];
                 };

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
             };

             bing.metaData.hidden = true;
             google.metaData.alias = "@g";
           };
           default = "Startpage";
           privateDefault = "Startpage";
           order = [ "Startpage" ];
         };

         bookmarks = {
           force = true;
           settings = [
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
               ];
             }
           ];
         };
         containers = {
           dangerous = {
             color = "red";
             icon = "fruit";
             id = 2;
           };
           shopping = {
             color = "blue";
             icon = "cart";
             id = 1;
           };
         };

       };
    */
  };
}
