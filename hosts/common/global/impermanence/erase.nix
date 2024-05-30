{
  boot.initrd = {
    enable = true;
    systemd.enable = true;
    supportedFilesystems = ["btrfs"];

    systemd.services.restore-root = {
      description = "Rollback btrfs rootfs";
      wantedBy = ["initrd.target"];
      requires = [
        "dev-mapper-${disk}\\x2dcrypt.device"
      ];
      after = [
        "dev-mapper-${disk}\\x2dcrypt.device"
        # for luks
        #"systemd-cryptsetup@${config.networking.hostName}.service"
        "systemd-cryptsetup@${disk}\\x2dcrypt.service"
      ];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt

        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvol=/ /dev/mapper/${disk}-crypt /mnt

        # While we're tempted to just delete /@ROOT and create
        # a new snapshot from /@ROOT-BLANK, /@ROOT is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        #
        # /@ROOT contains subvolumes:
        # - /@ROOT/var/lib/portables
        # - /@ROOT/var/lib/machines
        #
        # I suspect these are related to systemd-nspawn, but
        # since I don't use it I'm not 100% sure.
        # Anyhow, deleting these subvolumes hasn't resulted
        # in any issues so far, except for fairly
        # benign-looking errors from systemd-tmpfiles.
        btrfs subvolume list -o /mnt/@ROOT |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /@ROOT subvolume..." &&
        btrfs subvolume delete /mnt/@ROOT

        echo "restoring blank /@ROOT subvolume..."
        btrfs subvolume snapshot /mnt/@ROOT-BLANK /mnt/@ROOT

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
    };
  };
}
