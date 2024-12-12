{pkgs, ...}: {
  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = ["user-with-access-to-virtualbox"];

  virtualisation.libvirtd.enable = true;
  #programs.virt-manager.enable = true;
  users.users.egor.extraGroups = ["libvirtd"];
  environment.systemPackages = with pkgs; [
    gnome-boxes
  ];
}
