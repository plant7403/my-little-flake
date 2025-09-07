{ config, ... }:
# TODO - Review
{
  imports = [
    ../../common/optional/syncthing
  ];
  sops.secrets."services/syncthing/stellar/key" = { };
  sops.secrets."services/syncthing/stellar/cert" = { };
  services = {
    syncthing = {
      key = config.sops.secrets."services/syncthing/stellar/key".path;
      cert = config.sops.secrets."services/syncthing/stellar/cert".path;
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
          pixel8 = {
            id = "FR6RKN5-N7WNOUT-7G2HLO2-DXV27JC-7764HKZ-HTYXDXR-X5ACXVT-DAEC3Q6";
          };
          horizon = {
            id = "HTZC5JU-K76VDI7-O7NWKR5-Q7MYG2Z-MDAHXES-GRQ5AMI-JXNT7BI-KIVJ4AC";
          };
        };
        folders = {
          "/home/egor/Sync" = {
            # Name of folder in Syncthing, also the folder ID
            id = "Sync"; # Which folder to add to Syncthing
            devices = [
              "immortal"
              "luna"
              "pixel8"
              "pixel6"
              "horizon"
            ]; # Which devices to share the folder wi
          };
          "/home/egor/Documentos" = {
            id = "Documents";
            devices = [
              "immortal"
              "luna"
              "pixel8"
              "pixel6"
              "horizon"

            ];
            #ignorePerms = false; # By default, Syncthing doesn't sync file permissi
          };
          "/home/egor/.Secret" = {
            id = ".Secret";
            devices = [
              "immortal"
              "luna"
              "pixel8"
              "pixel6"
              "horizon"

            ];
          };
          "/home/egor/.DecSync" = {
            id = ".DecSync";
            devices = [
              "immortal"
              "luna"
              "pixel8"
              "pixel6"
              "horizon"

            ];
          };
          "/home/egor/DCIM" = {
            id = "DCIM";
            devices = [
              "immortal"
              "pixel8"
              "pixel6"
            ];
          };
          "/home/egor/Musica" = {
            id = "Music";
            devices = [
              "immortal"
              "pixel8"
              "pixel6"
            ];
          };
        };
      };
    };
  };
}
