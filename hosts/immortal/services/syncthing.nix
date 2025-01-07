{config, ...}: {
  imports = [
    ../../common/optional/syncthing
  ];
  sops.secrets."services/syncthing/immortal/key" = {};
  sops.secrets."services/syncthing/immortal/cert" = {};
  services = {
    syncthing = {
      guiAddress = "0.0.0.0:8384";
      key = config.sops.secrets."services/syncthing/immortal/key".path;
      cert = config.sops.secrets."services/syncthing/immortal/cert".path;
      settings = {
        gui = {
          theme = "black";
          user = "banana";
          password = "$2b$05$dNfYNEmnLC3nrJ9N2Pl78OYVdNSlQ1sDcXfX1APEcqRq8ujetcPIa";
        };
        devices = {
          luna = {id = "J7XMOAJ-P46MLGT-FIXSDMK-4XRDF6M-VFWRHBN-2TLP23V-I2TKCMB-SUZJ7AN";};
          pixel6 = {id = "6JHCNHN-KJ3AEVM-GH6GYAA-F3M4E4N-2GQL7X5-26L36YQ-6F5D52A-WCL3DA5";};
          saturn = {id = "XMAHULY-LAPHEIW-Q2LJX7M-6DTS7H5-HJZT6RF-QUOTXFJ-ERPXQBX-CFYWIQC";};
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

  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "syncthing";
      upstream = "http://127.0.0.1:8384";
      tor.enable = true;
      tor.authelia = false;
    }
  ];
  #users.groups.sync = {};
  #users.groups.sync.members = ["egor" "photoprism"];
  #users.groups.photoprism.members = ["photoprism" "egor"];
  users.users.egor = {extraGroups = ["photoprism"];};
  #users.users.photoprism.extraGroups = ["sync"];
  #  "acme"
  #];
}
