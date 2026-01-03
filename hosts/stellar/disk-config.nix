{ config, lib, ... }:
{
  disko.devices = {
    disk = {
      nvme.type = "disk";
      nvme.device = "/dev/nvme0n1";
      nvme.content.type = "gpt";
      nvme.content.partitions = {
        ESP.size = "512M";
        ESP.type = "EF00";
        ESP.content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [
            "defaults"
            "discard"
          ];
        };
        luks.size = "100%";
        luks.content.type = "luks";
        luks.content.name = "nvme-crypt";
        luks.content.passwordFile = lib.mkIf (
          config.boot.initrd.clevis.devices."nvme-crypt".secretFile == null
        ) config.sops.secrets."encryption/stellar".path;
        luks.content.settings = {
          allowDiscards = false;
          keyFile = lib.mkIf (
            config.boot.initrd.clevis.devices."nvme-crypt".secretFile == null
          ) config.sops.secrets."encryption/stellar".path;
        };
        luks.content.additionalKeyFiles = lib.mkIf (
          config.boot.initrd.clevis.devices."nvme-crypt".secretFile == null
        ) [ config.sops.secrets."encryption/stellar".path ];
        luks.content.content.type = "btrfs";
        luks.content.content.extraArgs = [ "-f" ];
        luks.content.content.postCreateHook =
          # syntax: sh
          ''
            MNTPOINT=$(mktemp -d)
            mount "/dev/mapper/nvme-crypt" "$MNTPOINT" -o subvol=/
            trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
            btrfs subvolume snapshot -r $MNTPOINT/@ROOT $MNTPOINT/@ROOT-BLANK
            MNTPOINT=$(mktemp -d)
            mount "/dev/mapper/nvme-crypt" "$MNTPOINT" -o subvol=/
            trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
            btrfs subvolume snapshot -r $MNTPOINT/@HOME $MNTPOINT/@HOME-BLANK
          '';
        luks.content.content.subvolumes = {
          "/@ROOT" = {
            mountpoint = "/";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "/@HOME" = {
            mountpoint = "/home";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "/@NIX" = {
            mountpoint = "/nix";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "/@PERSIST" = {
            mountpoint = "/persist";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "/@LOG" = {
            mountpoint = "/var/log";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "/@SNAPSHOTS" = {
            mountpoint = "/.snapshots";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "/@SWAP" = {
            mountpoint = "/.swapvol";
            swap.swapfile.size = "8G";
          };
        };
      };
    };
  };
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;

  sops.secrets."encryption/stellar" = { };
}
