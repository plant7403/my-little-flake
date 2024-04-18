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
          surface = {id = "VYJTVH2-EB6Y5NH-GOY6ZCK-4W7MCBD-EY5NN2K-BSAYKDF-E6AT4Q3-Q2NAZQI";};
          pixel6 = {id = "6JHCNHN-KJ3AEVM-GH6GYAA-F3M4E4N-2GQL7X5-26L36YQ-6F5D52A-WCL3DA5";};
          immortal = {id = "HOYMAKE-ZN44TBY-LVD5YVO-ML57TIP-Z2HDDLO-BB5OSBM-XYD43WX-DOPPZAJ";};
        };
        folders = {
          "/home/egor/Sync" = {
            # Name of folder in Syncthing, also the folder ID
            id = "Sync"; # Which folder to add to Syncthing
            devices = ["immortal" "surface" "pixel6"]; # Which devices to share the folder wi
          };
          "/home/egor/Documents" = {
            id = "Documents";
            devices = ["immortal" "surface" "pixel6"];
            #ignorePerms = false; # By default, Syncthing doesn't sync file permissi
          };
          "/home/egor/.Secret" = {
            id = ".Secret";
            devices = ["immortal" "surface" "pixel6"];
          };
          "/home/egor/.DecSync" = {
            id = ".DecSync";
            devices = ["immortal" "surface" "pixel6"];
          };
          "/home/egor/DCIM" = {
            id = "DCIM";
            devices = ["immortal" "pixel6"];
          };
        };
      };
    };
  };
  environment.persistence."/persist".directories = [
    "/var/lib/syncthing"
  ];
}
