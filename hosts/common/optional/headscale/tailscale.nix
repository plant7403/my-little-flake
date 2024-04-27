{
  config,
  lib,
  ...
}: {
  services.tailscale.enable = true;
  services.tailscale = {
    useRoutingFeatures = lib.mkDefault "client";
    extraUpFlags = ["--login-server https://head.egor.wtf"];
  };
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  #networking.firewall.allowedUDPPorts = [41641];
}
