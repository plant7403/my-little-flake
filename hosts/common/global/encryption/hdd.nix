# FIXME - This probably causes boot to break
{config, ...}: {
  #boot.initrd.luks.devices."hdd-crypt".device = "/dev/disk/by-uuid/faaf4823-7b06-4aec-9f6e-701ffc1390c6";
  boot.initrd.systemd.enable = true;

  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "r8169" "iwlwifi" "rtsx_pci_sdmmc"]; # some kernel modules required for networking in initrd, the latter two I obtained by running `lspci -v | grep -iA8 'network\|ethernet' | grep 'Kernel modules'`

  #boot.plymouth.enable = true;
  #boot.initrd.network.enable = true;
  #boot.initrd.network.udhcpc.enable = true;
  boot.initrd.clevis.enable = true;
  #boot.initrd.clevis.useTang = false;
  #boot.initrd.clevis.devices."hdd-crypt".secretFile = config.sops.secrets."encryption/immortal".path; #test
  #boot.initrd.clevis.devices."faaf4823-7b06-4aec-9f6e-701ffc1390c6".secretFile = /root/hi.jwe;
  boot.initrd.systemd.enableTpm2 = true;
  #sops.secrets."encryption/immortal" = {};
  #luks-b490debe-94b7-4b20-9abf-7eccfa36c8d3
  #fileSystems."/hdd" = {
  #  depends = [
  # The mounts above have to be mounted in this given order
  #    "/"
  #    "/persist"
  #    "/nix"
  #  ];
  #  device = "/dev/mapper/hdd";
  #  fsType = "btrfs";
  #  neededForBoot = false;
  #  options = [
  #    "noatime"
  #"bind"
  #"ro" # The filesystem hierarchy will be read-only when accessed from /mnt/aggregator/app1
  #  ];
  #};
}
