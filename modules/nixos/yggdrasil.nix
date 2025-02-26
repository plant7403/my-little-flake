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
  };
}
