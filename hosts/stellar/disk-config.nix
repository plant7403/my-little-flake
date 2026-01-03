{ config, ... }:
{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "discard"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "nvme-crypt";
                # disable settings.keyFile if you want to use interactive password entry
                #passwordFile = config.sops.secrets."encryption/stellar".path; # Interactive
                #keyFile = config.sops.secrets."encryption/stellar".path;
                settings = {
                  allowDiscards = false;
                  #keyFile = config.sops.secrets."encryption/stellar".path;
                };
                #additionalKeyFiles = ["/tmp/additionalSecret.key"];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  postCreateHook =
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
                  subvolumes = {
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
