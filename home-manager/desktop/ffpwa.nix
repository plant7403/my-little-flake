{pkgs, ...}:{

  programs.firefoxpwa.enable = "true";
  #programs.firefoxpwa.settings = "";
  programs.firefoxpwa.profiles = {
    "Default" = {
      name = "";
      settings = "";
      sites = {
        "Cloudflare" = {
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
}
