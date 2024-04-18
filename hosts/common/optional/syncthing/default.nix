{pkgs, config, ...}: {
  # TODO - Review
  services = {
    syncthing = {
      enable = true;
      package = pkgs.syncthing;
      user = "egor";
      group = "sync";
      dataDir = "/home/egor/.config/syncthing";
      #configDir = "/home/egor/Documents/.config/syncthing";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
    };
  };
  users.groups.sync = {};
  #users.groups.sync.members = [ "syncthing" "egor"];
  #users.groups.syncthing.members = [ "syncthing" "egor"];
  # Syncthing ports
  networking.firewall.allowedTCPPorts = [22000];
  networking.firewall.allowedUDPPorts = [22000 21027];

  environment.persistence."/persist".directories = [
    "/var/lib/syncthing"
  ];
}
