{
  pkgs,
  config,
  lib,
  #sops-nix,
  ...
}:
#with lib;
let
  cfg = config.modules.syncthing;

  all_devices = [
    "immortal"
    "stellar"
    #"horizon"
    "pixel8"
    "pixel6"
  ];
in
{
  options = {
    modules.syncthing = {
      enable = lib.mkEnableOption "service";
    };
  };
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      #allProxy = "socks5://address.com:1234";
      cert = config.sops.secrets."syncthing/cert".path;
      enable = true;
      #extraOptions = [ "--test" ];
      #guiAddress = "127.0.0.1:8384";
      key = config.sops.secrets."syncthing/key".path;
      overrideDevices = true;
      overrideFolders = true;
      passwordFile = config.sops.secrets."syncthing/password".path;
      settings = {
        devices = {
          immortal = {
            id = "HOYMAKE-ZN44TBY-LVD5YVO-ML57TIP-Z2HDDLO-BB5OSBM-XYD43WX-DOPPZAJ";
          };
          stellar = {
            id = "CA3XBIH-S6U2TFK-LX5VJBS-SMZXGSI-2UM6PO2-AN4MM4J-2NLKLQL-UKEO7Q6";
          };
          /*
            horizon = {
              id = "test";
            };
          */
          pixel8 = {
            id = "FR6RKN5-N7WNOUT-7G2HLO2-DXV27JC-7764HKZ-HTYXDXR-X5ACXVT-DAEC3Q6";
          };
          pixel6 = {
            id = "6JHCNHN-KJ3AEVM-GH6GYAA-F3M4E4N-2GQL7X5-26L36YQ-6F5D52A-WCL3DA5";
          };

        };
        folders = {
          "${config.xdg.userDirs.documents}" = {
            id = "Documents";
            devices = [

            ]
            ++ all_devices;
          };
          "${config.xdg.userDirs.music}" = {
            id = "Music";
            devices = [

            ]
            ++ all_devices;
          };
          "${config.xdg.userDirs.pictures}" = {
            id = "Pictures";
            devices = [
            ]
            ++ all_devices;
          };
          "Sync" = {
            id = "Sync";
            devices = [

            ]
            ++ all_devices;
            path = "${config.home.homeDirectory}/Sync";
          };

          ".Secret" = {
            id = ".Secret";
            devices = [

            ]
            ++ all_devices;
            path = "${config.home.homeDirectory}/.Secret";
          };
          ".DecSync" = {
            id = ".DecSync";
            devices = [

            ]
            ++ all_devices;
            path = "${config.home.homeDirectory}/.DecSync";
          };
          "DCIM" = {
            id = "DCIM";
            devices = [
              "pixel8"
            ];
            path = "${config.home.homeDirectory}/DCIM";
          };
        };
        options = {
          #limitBandwidthInLan = null;
          #localAnnounceEnabled = null;
          #localAnnouncePort = null;
          #maxFolderConcurrency = null;
          relaysEnabled = true;
          urAccepted = -1;
        };
      };
      #tray.command = "";
      tray.enable = true;
      tray.package = pkgs.syncthingtray-minimal;
    };
    sops.secrets."syncthing/cert" = { };
    sops.secrets."syncthing/key" = { };
    sops.secrets."syncthing/password" = {
      sopsFile = ./../../home-manager/secrets/common.yaml;
    };
    systemd.user.services.syncthing.service = {
      waitFor = [ "sops-nix" ];
    };

    /*
      Service = {
        ExecStart = "${pkgs.writeShellScript "watch-store" ''
          #!/run/current-system/sw/bin/bash
          ATTIC_TOKEN=$(cat ${config.sops.secrets.attic_auth_token.path})
          ${pkgs.attic}/bin/attic login prod https://majiy00-nix-binary-cache.fly.dev $ATTIC_TOKEN
          ${pkgs.attic}/bin/attic use prod
          ${pkgs.attic}/bin/attic watch-store prod:prod
        ''}";
      };
    */
  };

}
