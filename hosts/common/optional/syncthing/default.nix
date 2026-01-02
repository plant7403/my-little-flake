{
  pkgs,
  ...
}: {
  services = {
    syncthing = {
      enable = true;
      package = pkgs.syncthing;
      user = "egor";
      group = "sync";
      dataDir = "/home/egor/.syncthing";
      configDir = "/home/egor/.config/syncthing";
      #extraFlags = [
      #  "--allow-newer-config"
      #];
      #configDir = "/home/egor/.config/syncthing";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
    };
  };
  users.groups.sync = {};
  users.users.egor.extraGroups = ["sync"];
  #users.groups.sync.members = [ "syncthing" "egor"];
  #users.groups.syncthing.members = [ "syncthing" "egor"];
  #users.users.nginx.extraGroups = [
  #  "acme"
  #];
  # Syncthing ports
  networking.firewall.allowedTCPPorts = [22000];
  networking.firewall.allowedUDPPorts = [22000 21027];
}
