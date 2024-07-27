{
  pkgs,
  config,
  ...
}: {
  services.transmission = {
    enable = true;
    user = "transmission";
    group = "media";
    package = pkgs.transmission_4;
    webHome = pkgs.flood-for-transmission;
    #openFirewall = true;
    #openRPCPort = true;
    settings = {
      #home = "/data/.transmission";
      download-dir = "/hdd/Media";
      #incomplete-dir = "/data/Media";
      incomplete-dir-enabled = false;
      #watch-dir = "/DATA/D1/TM/watch";
      watch-dir-enabled = false;
      rpc-bind-address = "0.0.0.0";
      rpc-port = 9099;
      rpc-host-whitelist = "torr.egor.wtf";
      #rpc-whitelist = "192.168.1.*";
    };
  };
  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "torr";
      upstream = "http://127.0.0.1:9099";
    }
  ];
  users.groups.media = {};

  sops.secrets."services/transmission" = {
    owner = "nginx";
  };
  environment.persistence."/persist".directories = [
    "/var/lib/transmission"
  ];
}
