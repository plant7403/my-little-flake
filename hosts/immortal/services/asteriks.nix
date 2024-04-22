{
  config,
  lib,
  pkgs,
  ...
}: {
  services.asterisk = {
    enable = true;
    confFiles = {
      # config files go here
      #pjsip.conf
    };
  };
  # we had a sepearte VLAN for this, so *shrug*
  # makes things easier if I don't have to keep track of ports
  networking.firewall.enable = false;
}
