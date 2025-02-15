{ pkgs, ... }: {
  programs.librewolf = {
    enable = true;
    profiles.default = {
      /*       extentions = with inputs.firefox-addons.packages.${pkgs.system};
        [
          privacy-badger
        ]; */
      /*       extensions = with pkgs; [
        # installing bitwarden and ublock-origin through nur
        nur.repos.rycee.firefox-addons.bitwarden
        nur.repos.rycee.firefox-addons.ublock-origin
      ];
       */
      search = {
        force = true;
        engines = {
          "Bing".metaData.hidden = true;
          "Google".metaData.hidden = true;
        };
        default = "DuckDuckGo";
        privateDefault = "DuckDuckGo";
        order = [ "DuckDuckGo" ];
      };
      bookmarks = [
        {
          name = "wikipedia";
          tags = [ "wiki" ];
          keyword = "wiki";
          url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
        }
        {
          name = "kernel.org";
          url = "https://www.kernel.org";
        }
        {
          name = "Nix sites";
          toolbar = true;
          bookmarks = [
            {
              name = "homepage";
              url = "https://nixos.org/";
            }
            {
              name = "wiki";
              tags = [ "wiki" "nix" ];
              url = "https://wiki.nixos.org/";
            }
          ];
        }
      ];

    };
  };
  programs.chromium.enable = true;
}
