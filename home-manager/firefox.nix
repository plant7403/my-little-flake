{ pkgs, inputs, ... }:
{

  stylix.targets.librewolf = {
    colorTheme.enable = true;
    firefoxGnomeTheme.enable = true;
    profileNames = [ "default" ];
  }; # !!! remove it from here !!!

  programs.librewolf = {
    enable = true;
    settings = {
      #"browser.tabs.tabMinWidth" = 5;
    };
    languagePacks = [
      "es-ES"
      "en-US"
    ];
    profiles.default = {
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
      };
      search = {
        force = true;
        engines = {
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

          bing.metaData.hidden = true;
          google.metaData.alias = "@g";
          startpage = {
            name = "StartPage";
            urls = [
              { template = "https://www.startpage.com/sp/search?query={searchTerms}&cat=web&pl=opensearch"; }
            ];
            iconMapObj."16" = "https://startpage.com/sp/cdn/favicons/favicon-16x16-gradient.png";
            definedAliases = [ "@sp" ];
          };
          # builtin engines only support specifying one additional alias
        };
        default = "sp";
        privateDefault = "sp";
        order = [ "sp" ];
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
          ];
        }
      ];

    };
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

          bing.metaData.hidden = true;
          google.metaData.alias = "@g";
          startpage = {
            name = "StartPage";
            urls = [
              { template = "https://www.startpage.com/sp/search?query={searchTerms}&cat=web&pl=opensearch"; }
            ];
            iconMapObj."16" = "https://startpage.com/sp/cdn/favicons/favicon-16x16-gradient.png";
            definedAliases = [ "@sp" ];
          };
          # builtin engines only support specifying one additional alias
        };
        default = "startpage";
        privateDefault = "startpage";
        order = [ "startpage" ];
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
  };
}
