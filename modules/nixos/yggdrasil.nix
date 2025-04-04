{ lib, config, ... }:
with lib;
let
  cfg = config.modules.yggdrasil;
in
{
  options.modules.yggdrasil = {
    enable = mkEnableOption "service";
    /*
      yggdrasil = mkOption {
         type = types.str;
         default = "default";
       };
    */

  };

  config = mkIf cfg.enable {
    services.yggdrasil = {
      openMulticastPort = true;
      enable = true;
      persistentKeys = true;
      settings = {
        Peers = [
          "quic://spain.magicum.net:36900"
          "tls://spain.magicum.net:36901"
          "tcp://rendezvous.anton.molyboha.me:50421"
        ];
      };
    };
    networking.hosts = {
      "200:d3b0:9e2f:647b:dc20:a133:ef09:a697" = [
        "egor.wtf"
        "cloud.egor.wtf"
        "password.egor.wtf"
        "jelly.egor.wtf"
        "photos.egor.wtf"
        "git.egor.wtf"
        "auth.egor.wtf"
      ];
    };
  };
}
