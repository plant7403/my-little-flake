{ pkgs, inputs, ... }:
{
  programs.librewolf = {
    enable = true;
    profiles.default = {
      extensions.packages =
        with pkgs;
        with inputs.firefox-addons.packages.${pkgs.system};
        [
          darkreader
          ublock-origin
          libredirect
          keepassxc-browser
        ];

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
  };
}
