{...}:
# FIXME - Cheange paths to a user directory
# TODO - Migrate to home-manager
{
  imports = [
    ../../common/optional/syncthing
  ];
  services = {
    syncthing = {
      guiAddress = "0.0.0.0:8384";
      settings = {
        devices = {
          surface = {id = "VYJTVH2-EB6Y5NH-GOY6ZCK-4W7MCBD-EY5NN2K-BSAYKDF-E6AT4Q3-Q2NAZQI";};
          pixel6 = {id = "6JHCNHN-KJ3AEVM-GH6GYAA-F3M4E4N-2GQL7X5-26L36YQ-6F5D52A-WCL3DA5";};
          saturn = {id = "26XZV72-2JZMWXQ-BD7GE6M-A6Z7YPR-JBO4XJ4-WMEOU5U-67YOTNC-S3HONAK";};
        };
        folders = {
          "/home/egor/syncthing/Sync" = {
            # Name of folder in Syncthing, also the folder ID
            id = "Sync"; # Which folder to add to Syncthing
            devices = ["surface" "pixel6" "saturn"]; # Which devices to share the folder wi
          };
          "/home/egor/syncthing/Documents" = {
            id = "Documents";
            devices = ["surface" "pixel6" "saturn"];
            #ignorePerms = false; # By default, Syncthing doesn't sync file permissi
          };
          "/home/egor/syncthing/.Secret" = {
            id = ".Secret";
            devices = ["surface" "pixel6" "saturn"];
          };
          "/home/egor/syncthing/.DecSync" = {
            id = ".DecSync";
            devices = ["surface" "pixel6" "saturn"];
          };
          "/home/egor/syncthing/DCIM" = {
            id = "DCIM";
            devices = ["pixel6"];
          };
        };
      };
    };
  };
  #fileSystems."/home/egor/syncthing/DCIM" = {
  #  device = "/data/Import";
  #  options = ["bind"];
  #};
}
