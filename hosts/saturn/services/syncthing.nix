{...}:
# TODO - Review
{
  imports = [
    ../../common/optional/syncthing
  ];
  services = {
    syncthing = {
      settings = {
        devices = {
          luna = {id = "J7XMOAJ-P46MLGT-FIXSDMK-4XRDF6M-VFWRHBN-2TLP23V-I2TKCMB-SUZJ7AN";};
          pixel6 = {id = "6JHCNHN-KJ3AEVM-GH6GYAA-F3M4E4N-2GQL7X5-26L36YQ-6F5D52A-WCL3DA5";};
          immortal = {id = "U2FLNWL-RAQPG44-7UQG6OP-XEHFIA5-Q6LPK6M-2HOSDL4-ID4SJIF-5SCCWQD";};
        };
        folders = {
          "/home/egor/Sync" = {
            # Name of folder in Syncthing, also the folder ID
            id = "Sync"; # Which folder to add to Syncthing
            devices = ["immortal" "luna" "pixel6"]; # Which devices to share the folder wi
          };
          "/home/egor/Documents" = {
            id = "Documents";
            devices = ["immortal" "luna" "pixel6"];
            #ignorePerms = false; # By default, Syncthing doesn't sync file permissi
          };
          "/home/egor/.Secret" = {
            id = ".Secret";
            devices = ["immortal" "luna" "pixel6"];
          };
          "/home/egor/.DecSync" = {
            id = ".DecSync";
            devices = ["immortal" "luna" "pixel6"];
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
