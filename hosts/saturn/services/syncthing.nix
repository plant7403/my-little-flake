{ config, ... }:
# TODO - Review
{
  imports = [
    ../../common/optional/syncthing
  ];
  sops.secrets."services/syncthing/saturn/key" = { };
  sops.secrets."services/syncthing/saturn/cert" = { };
  services = {
    syncthing = {
      key = config.sops.secrets."services/syncthing/saturn/key".path;
      cert = config.sops.secrets."services/syncthing/saturn/cert".path;
      settings = {
        gui = {
          theme = "black";
          user = "banana";
          password = "$2b$05$dNfYNEmnLC3nrJ9N2Pl78OYVdNSlQ1sDcXfX1APEcqRq8ujetcPIa";
        };
        devices = {
          luna = {
            id = "J7XMOAJ-P46MLGT-FIXSDMK-4XRDF6M-VFWRHBN-2TLP23V-I2TKCMB-SUZJ7AN";
          };
          pixel6 = {
            id = "6JHCNHN-KJ3AEVM-GH6GYAA-F3M4E4N-2GQL7X5-26L36YQ-6F5D52A-WCL3DA5";
          };
          immortal = {
            id = "Q7IVU3I-JUVBJ5K-JNF7L7Z-HA33DU4-OXIRQ6J-QL4QWAA-JQKBPR6-TRXA6AW";
          };
        };
        folders = {
          "/home/egor/Sync" = {
            # Name of folder in Syncthing, also the folder ID
            id = "Sync"; # Which folder to add to Syncthing
            devices = [
              "immortal"
              "luna"
              "pixel6"
            ]; # Which devices to share the folder wi
          };
          "/home/egor/Documents" = {
            id = "Documents";
            devices = [
              "immortal"
              "luna"
              "pixel6"
            ];
            #ignorePerms = false; # By default, Syncthing doesn't sync file permissi
          };
          "/home/egor/.Secret" = {
            id = ".Secret";
            devices = [
              "immortal"
              "luna"
              "pixel6"
            ];
          };
          "/home/egor/.DecSync" = {
            id = ".DecSync";
            devices = [
              "immortal"
              "luna"
              "pixel6"
            ];
          };
          #"/home/egor/DCIM" = {
          #  id = "DCIM";
          #  devices = [ "immortal" "pixel6" ];
          #};
        };
      };
    };
  };
}
