{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.yubikey-unlock;

  all_devices = [
    "immortal"
    "stellar"
    "horizon"
    "pixel8"
    "pixel6"
  ];
in
{
  options = {
    modules.yubikey-unlock = {
      enable = mkEnableOption "service";
      /*
        host = mkOption {
          type = types.str;
          default = "default";
        };
      */
    };
  };
  config = {
    services.syncthing = {
      #allProxy = "socks5://address.com:1234";
      cert = config.sops.secrets."syncthing.cert".path;
      enable = true;
      #extraOptions = [ "--test" ];
      guiAddress = "127.0.0.1:8384";
      key = config.sops.secrets."syncthing.key".path;
      overrideDevices = true;
      overrideFolders = true;
      passwordFile = config.sops.secrets."syncthing.password".path;
      settings = {
        devices = {
          immortal = {
            id = "HOYMAKE-ZN44TBY-LVD5YVO-ML57TIP-Z2HDDLO-BB5OSBM-XYD43WX-DOPPZAJ";
          };
          stellar = {
            id = "test";
          };
          horizon = {
            id = "test";
          };
          pixel8 = {
            id = "test";
          };
          pixel6 = {
            id = "6JHCNHN-KJ3AEVM-GH6GYAA-F3M4E4N-2GQL7X5-26L36YQ-6F5D52A-WCL3DA5";
          };

        };
        folders = {
          "${config.xdg.userDirs.documents}" = {
            id = "Documents";
            devices = [

            ];
          };
          "${config.xdg.userDirs.music}" = {
            id = "Music";
            devices = [

            ];
          };
          "${config.xdg.userDirs.pictures}" = {
            id = "Pictures";
            devices = [

            ];
          };
          "/home/egor/Sync" = {
            id = "Sync";
            devices = [

            ];
          };

          "/home/egor/.Secret" = {
            id = ".Secret";
            devices = [

            ];
          };
          "/home/egor/.DecSync" = {
            id = ".DecSync";
            devices = [

            ];
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
  };
  sops.secrets."syncthing/cert" = { };
  sops.secrets."syncthing/key" = { };
  sops.secrets."syncthing/password" = {
    sopsFile = ./secrets/common.yaml;
  };
}
