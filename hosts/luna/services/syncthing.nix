{ ... }:
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
          pixel6 = {
            id = "6JHCNHN-KJ3AEVM-GH6GYAA-F3M4E4N-2GQL7X5-26L36YQ-6F5D52A-WCL3DA5";
          };
          immortal = {
            id = "Q7IVU3I-JUVBJ5K-JNF7L7Z-HA33DU4-OXIRQ6J-QL4QWAA-JQKBPR6-TRXA6AW";
          };
          saturn = {
            id = "XMAHULY-LAPHEIW-Q2LJX7M-6DTS7H5-HJZT6RF-QUOTXFJ-ERPXQBX-CFYWIQC";
          };
        };
        folders = {
          "/home/egor/Sync" = {
            # Name of folder in Syncthing, also the folder ID
            id = "Sync"; # Which folder to add to Syncthing
            devices = [
              "immortal"
              "pixel6"
              "saturn"
            ]; # Which devices to share the folder wi
          };
          "/home/egor/Documents" = {
            id = "Documents";
            devices = [
              "immortal"
              "pixel6"
              "saturn"
            ];
            #ignorePerms = false; # By default, Syncthing doesn't sync file permissi
          };
          "/home/egor/.Secret" = {
            id = ".Secret";
            devices = [
              "immortal"
              "pixel6"
              "saturn"
            ];
          };
          "/home/egor/.DecSync" = {
            id = ".DecSync";
            devices = [
              "immortal"
              "pixel6"
              "saturn"
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
  users.users.egor.extraGroups = [ "sync" ];
}
