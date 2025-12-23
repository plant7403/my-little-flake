{ pkgs, inputs, ... }:
{

  programs.firefoxpwa.enable = true;
  #programs.firefoxpwa.settings = "";
  programs.firefoxpwa.profiles = {
    /*
      "MAIN" = {
        name = "";
        settings = "";
        sites = {
          "CDFR" = {
            name = "MDN Web Docs";
            url = "https://developer.mozilla.org/";
            manifestUrl = "https://developer.mozilla.org/manifest.f42880861b394dd4dc9b.json";
            desktopEntry.icon = pkgs.fetchurl {
              url = "https://developer.mozilla.org/favicon-192x192.png";
              sha256 = "0p8zgf2ba48l2pq1gjcffwzmd9kfmj9qc0v7zpwf2qd54fndifxr";
            };
          };
        };
      };
    */
  };
  home.packages = with pkgs; [
    pkgs.firefoxpwa
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts =
      with pkgs;
      with inputs.firefox-addons.packages.${pkgs.system};
      [ firefoxpwa ];
  };
  programs.librewolf = {
    enable = true;
    nativeMessagingHosts =
      with pkgs;
      with inputs.firefox-addons.packages.${pkgs.system};
      [ firefoxpwa ];
  };
}
