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
          #surface = {id = "VYJTVH2-EB6Y5NH-GOY6ZCK-4W7MCBD-EY5NN2K-BSAYKDF-E6AT4Q3-Q2NAZQI";};
          pixel6 = {id = "6JHCNHN-KJ3AEVM-GH6GYAA-F3M4E4N-2GQL7X5-26L36YQ-6F5D52A-WCL3DA5";};
          immortal = {id = "U2FLNWL-RAQPG44-7UQG6OP-XEHFIA5-Q6LPK6M-2HOSDL4-ID4SJIF-5SCCWQD";};
          saturn = {id = "26XZV72-2JZMWXQ-BD7GE6M-A6Z7YPR-JBO4XJ4-WMEOU5U-67YOTNC-S3HONAK";};
        };
        folders = {
          "/home/egor/Sync" = {
            # Name of folder in Syncthing, also the folder ID
            id = "Sync"; # Which folder to add to Syncthing
            devices = ["immortal" "pixel6" "saturn"]; # Which devices to share the folder wi
          };
          "/home/egor/Documents" = {
            id = "Documents";
            devices = ["immortal" "pixel6" "saturn"];
            #ignorePerms = false; # By default, Syncthing doesn't sync file permissi
          };
          "/home/egor/.Secret" = {
            id = ".Secret";
            devices = ["immortal" "pixel6" "saturn"];
          };
          "/home/egor/.DecSync" = {
            id = ".DecSync";
            devices = ["immortal" "pixel6" "saturn"];
          };
          #"/home/egor/DCIM" = {
          #  id = "DCIM";
          #  devices = [ "immortal" "pixel6" ];
          #};
        };
      };
    };
  };
  users.users.egor.extraGroups = ["sync"];
}
