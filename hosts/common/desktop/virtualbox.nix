{ pkgs, ... }:
{
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "egor" ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      /*
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
          ];
        };
      */
    };
  };
}
