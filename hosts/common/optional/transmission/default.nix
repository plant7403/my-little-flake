{pkgs, ...}:
# TODO - Check alternatives
{
  services.transmission = {
    enable = true;
    user = "transmission";
    group = "media";
    package = pkgs.transmission;
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
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    virtualHosts."torr.egor.wtf" = {
      basicAuth = {
        #  #egor = config.sops.secrets."services/transmission".path;
        #  # FIXME - [IMPORTANT] Move to SOPS
        egor = config.sops.secrets."services/transmission".path;
      };
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        ${builtins.readFile ./../nginx/authelia/vh.conf}
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:9099";
        extraConfig = ''
          ${builtins.readFile ./../nginx/authelia/locations.conf}
        '';
      };
    };
  };
  users.groups.media = {};

  sops.secrets."services/transmission" = {
    owner = "nginx";
  };
  environment.persistence."/persist".directories = [
    "/var/lib/transmission"
  ];
}
