{ config, lib, ... }:
{
  sops.secrets."encryption/stellar" = { };

  boot.initrd.systemd.enable = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "r8169"
    # "iwlwifi"
    "nvme"
    "rtsx_pci_sdmmc"
  ]; # some kernel modules required for networking in initrd, the latter two I obtained by running `lspci -v | grep -iA8 'network\|ethernet' | grep 'Kernel modules'`

  #boot.plymouth.enable = true;

  #boot.initrd.network.enable = true;
  #boot.initrd.network.udhcpc.enable = true;
  #boot.initrd.clevis.useTang = false;
  boot.initrd.clevis.enable = true;

  boot.initrd.clevis.devices."nvme-crypt".secretFile =
    lib.mkForce
      config.sops.secrets."encryption/stellar".path;

  sops.secrets."encryption/stellar" = { };
}
