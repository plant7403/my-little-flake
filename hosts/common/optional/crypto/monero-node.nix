{config, ...}: {
  services.monero = {
    enable = true;
    dataDir = "/var/lib/monero";
    rpc = {
      address = "192.168.1.100";
    };
    extraConfig = ''
      confirm-external-bind=1
    '';
  };
  environment.persistence."/persist".directories = [
    config.services.monero.dataDir
  ];
  #sops.secrets."services/authelia/oidc/headscale/client_secret_enc" = {
  #  #owner = "authelia-prod";
  #};
  networking.firewall.allowedTCPPorts = [18081];
  #networking.firewall.allowedUDPPorts = [22000 21027];
}
