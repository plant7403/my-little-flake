{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.yggdrasil;
in {
  options.modules.yggdrasil = {
    enable = mkEnableOption "service";
    persist = mkOption {
      type = types.bool;
      default = false;
    };
    /*
    yggdrasil = mkOption {
       type = types.str;
       default = "default";
     };
    */
  };

  config = mkMerge [
    (mkIf cfg.enable {
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
        "200:a3e8:1542:4113:5b89:b0f2:c57:4e9a" = [
          "egor.wtf"
          "cloud.egor.wtf"
          "password.egor.wtf"
          "jelly.egor.wtf"
          "photos.egor.wtf"
          "git.egor.wtf"
          "auth.egor.wtf"
        ];
      };
    })

    (mkIf cfg.persist {
      environment.persistence."/persist".directories = [
        "/var/lib/yggdrasil"
      ];
    })
  ];
}
/*
stellar: 200:a3e8:1542:4113:5b89:b0f2:c57:4e9a
horizon: 201:4727:fe22:9178:4afa:d6ed:2fcf:7740
pixel8: 200:fbba:8d4a:91f0:58b6:ecef:2174:a96e
*/

