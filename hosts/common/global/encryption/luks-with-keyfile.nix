# FIXME - This probably causes boot to break
{
  ...
}: {
  #"..."

  # Kernel modules needed for mounting USB VFAT devices in initrd stage
  #boot.initrd.kernelModules = ["uas" "usbcore" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1"];

  # Mount USB key before trying to decrypt root filesystem
  #boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
  #  mkdir -m 0755 -p /key
  #  sleep 2 # To make sure the usb key has been loaded
  #  mount -n -t vfat -o ro `findfs UUID=${PRIMARYUSBID}` /key || mount -n -t vfat -o ro `findfs UUID=${BACKUPUSBID}` /key
  #'';

  #boot.initrd.luks.devices."ssd-crypt" = {
  #  device = "/dev/disk/by-uuid/5b92f660-cd05-4143-8601-ecab9f1ceafa";
  #  preLVM = false;
  #  keyFile = "/persist/passwords/ssd-keyfile";
  #  allowDiscard = true;
  #};
  environment.etc.crypttab = {
    enable = true;
    text = ''
      ssd-crypt UUID=5b92f660-cd05-4143-8601-ecab9f1ceafa /persist/passwords/ssd-keyfile luks
    '';
  };
  fileSystems."/ssd" = {
    depends = [
      # The mounts above have to be mounted in this given order
      "/"
      "/persist"
      "/nix"
    ];
    device = "/dev/mapper/ssd-crypt";
    fsType = "ext4";
    #neededForBoot = true;
    options = [
      "noatime"
      #"bind"
      #"ro" # The filesystem hierarchy will be read-only when accessed from /mnt/aggregator/app1
    ];
  };
}
