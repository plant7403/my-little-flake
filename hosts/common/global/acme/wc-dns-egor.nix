{
  lib,
  config,
  ...
}: let
  dnsName = "dns.egor.wtf";
in {
  sops.secrets."cloudflare/cf-dns.env" = {};
  # ...
  services.nginx.virtualHosts.${dnsName} = {
    serverAliases = ["*.${dnsName}"];
    enableACME = true;
  };

  security.acme.certs.${dnsName} = {
    dnsProvider = "cloudflare";
    credentialsFile = config.sops.secrets."cloudflare/cf-dns.env".path;
    # Disable webroot auth method
    webroot = lib.mkForce null;
  };
}
