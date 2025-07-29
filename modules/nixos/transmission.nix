{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.transmission;
in {
  options.modules.transmission = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    web = mkOption {
      type = types.bool;
      default = false;
    };
    sops = mkOption {
      type = types.bool;
      default = false;
    };
    persist = mkOption {
      type = types.bool;
      default = false;
    };
    user = mkOption {
      type = types.string;
      default = "egor";
    };
    group = mkOption {
      type = types.string;
      default = "users";
    };
    download-dir = mkOption {
      type = types.path;
      default = "/home/${cfg.user}/Downloads";
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      services.transmission = {
        enable = true;
        user = "${cfg.user}";
        group = "${cfg.group}";
        package = pkgs.transmission_4;
        webHome = pkgs.flood-for-transmission;
        openFirewall = true;
        openRPCPort = true;
        settings = {
          #home = "/data/.transmission";
          download-dir = "${cfg.download-dir}";
          #incomplete-dir = "/data/Media";
          incomplete-dir-enabled = false;
          #watch-dir = "/DATA/D1/TM/watch";
          watch-dir-enabled = false;
          rpc-bind-address = "0.0.0.0";
          rpc-port = 9099;
          rpc-host-whitelist = "torr.egor.wtf";
          #rpc-whitelist = "192.168.1.*";
          rpc-whitelist = "
          192.168.1.164, 
          192.168.1.186, 
          200:a3e8:1542:4113:5b89:b0f2:c57:4e9a, 
          200:fbba:8d4a:91f0:58b6:ecef:2174:a96e,
          127.0.0.1
          ";
        };
      };
      /*
      networking.firewall.interfaces."tun0".allowedTCPPorts = [
           9099
         ];
      */

      /*
      modules.web.vhosts = mkIf cfg.web [
           {
             domain = "egor.wtf.local";
             prefix = "torr";
             upstream = "http://127.0.0.1:9099";
           }
         ];
      */
      /*
      sops.secrets."services/transmission" = mkIf cfg.sops {
           #owner = "nginx";
         };
      */
    })

    (mkIf cfg.persist {
      environment.persistence."/persist".directories = [
        "/var/lib/transmission"
      ];
    })
  ];
  #path = config.sops.secrets."system/hostkeys/luna/ed25519".path;
  #sops.secrets."system/hostkeys/luna/rsa" = {};
}
