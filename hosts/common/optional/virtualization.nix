{ pkgs, ... }:
{
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  virtualisation = {
    virtualbox.host.enable = true;
    tpm.enable = true;
    libvirtd.enable = true;
    qemu.enable = true;
    waydroid = true;

    directBoot.enable = true;
    programs.virt-manager.enable = true;
    users.users.egor.extraGroups = [ "libvirtd" ];
    environment.systemPackages = with pkgs; [
      gnome-boxes
    ];
  };
}
