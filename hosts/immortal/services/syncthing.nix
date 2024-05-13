{...}:
# TODO - Review
{
  imports = [
    ../../common/optional/syncthing
  ];
  services = {
    syncthing = {
      guiAddress = "0.0.0.0:8384";
      settings = {
        devices = {
          luna = {id = "J7XMOAJ-P46MLGT-FIXSDMK-4XRDF6M-VFWRHBN-2TLP23V-I2TKCMB-SUZJ7AN";};
          pixel6 = {id = "6JHCNHN-KJ3AEVM-GH6GYAA-F3M4E4N-2GQL7X5-26L36YQ-6F5D52A-WCL3DA5";};
          #immortal = {id = "HOYMAKE-ZN44TBY-LVD5YVO-ML57TIP-Z2HDDLO-BB5OSBM-XYD43WX-DOPPZAJ";};
        };
        folders = {
          "/home/egor/Sync" = {
            # Name of folder in Syncthing, also the folder ID
            id = "Sync"; # Which folder to add to Syncthing
            devices = ["luna" "pixel6"]; # Which devices to share the folder wi
          };
          "/home/egor/Documents" = {
            id = "Documents";
            devices = ["luna" "pixel6"];
            #ignorePerms = false; # By default, Syncthing doesn't sync file permissi
          };
          "/home/egor/.Secret" = {
            id = ".Secret";
            devices = ["luna" "pixel6"];
          };
          "/home/egor/.DecSync" = {
            id = ".DecSync";
            devices = ["luna" "pixel6"];
          };
          "/data/Import" = {
            id = "DCIM";
            devices = ["pixel6"];
          };
        };
      };
    };
  };
  environment.persistence."/persist".directories = [
    "/var/lib/syncthing"
  ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    virtualHosts = {
      "syncthing.egor.wtf" = {
        forceSSL = true;
        useACMEHost = "egor.wtf";
        extraConfig = ''
          ${builtins.readFile ./../../common/optional/nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
          proxyWebsockets = true;
          extraConfig = ''
            ${builtins.readFile ./../../common/optional/nginx/authelia/locations.conf}
          '';
        };
      };
    };
  };
  #users.groups.sync = {};
  #users.groups.sync.members = ["egor" "photoprism"];
  users.groups.photoprism.members = ["photoprism" "egor"];
  #users.users.photoprism.extraGroups = ["sync"];
  #  "acme"
  #];
}
