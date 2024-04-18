{config, ...}: {
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
