{
  lib,
  pkgs,
  config,
  inputs,
  options,
  ...
}:
with lib; let
  # Shorter name to access final settings a
  # user of restore-root.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.modules.impermanence;
  inherit (lib) filterAttrs mkIf;
  regularSecrets = filterAttrs (n: v: !v.neededForUsers) config.sops.secrets;
in {
  # Declare what settings a user of this "restore-root.nix" module CAN SET.
  options.modules.impermanence = {
    enable = mkEnableOption "restore-root service";
    disk = mkOption {
      type = types.str;
      default = "default";
    };
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "restore-root.nix" module ENABLED this module
  # by setting "services.restore-root.enable = true;".
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./../../hosts/common/global/impermanence/sops-fix.nix
  ];
  config = mkMerge [
    (mkIf cfg.enable {
      environment.persistence."/persist" = {
        hideMounts = true;
        directories = [
          "/root"
          #"/etc/ssh"
          "/var/lib/nixos"
        ];
        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ];
      };
      programs.fuse.userAllowOther = true;

      system.activationScripts.persistent-dirs.text = let
        mkHomePersist = user:
          lib.optionalString user.createHome ''
            mkdir -p /persist/${user.home}
            chown ${user.name}:${user.group} /persist/${user.home}
            chmod ${user.homeMode} /persist/${user.home}
          '';
        users = lib.attrValues config.users.users;
      in
        lib.concatLines (map mkHomePersist users);

      security.sudo.extraConfig = ''
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never
      '';

      boot.initrd = {
        enable = true;
        systemd.enable = true;
        supportedFilesystems = ["btrfs"];

        systemd.services.restore-root = {
          description = "Rollback btrfs rootfs";
          wantedBy = ["initrd.target"];
          requires = [
            "dev-mapper-${cfg.disk}\\x2dcrypt.device"
          ];
          after = [
            "dev-mapper-${cfg.disk}\\x2dcrypt.device"
            # for luks
            #"systemd-cryptsetup@${config.networking.hostName}.service"
            "systemd-cryptsetup@${cfg.disk}\\x2dcrypt.service"
          ];
          before = ["sysroot.mount"];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /mnt

            # We first mount the btrfs root to /mnt
            # so we can manipulate btrfs subvolumes.
            mount -o subvol=/ /dev/mapper/${cfg.disk}-crypt /mnt

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
    })
    (mkIf (regularSecrets != {} && config.environment.persistence != {}) {
      system.activationScripts.setupSecrets.deps = ["persist-files"];
    })
  ];
}
