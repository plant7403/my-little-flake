{
  lib,
  config,
  ...
}:
let
  dnsName = "egor.wtf";
in
{
  sops.secrets."cloudflare/cf-dns.env" = { };
  # ...
  services.nginx.virtualHosts.${dnsName} = {
    serverAliases = [ "*.${dnsName}" ];
    enableACME = true;
  };
  services.nginx.virtualHosts."*.${dnsName}" = {
    useACMEHost = lib.mkForce "egor.wtf";
    enableACME = lib.mkForce false;
  };

  security.acme.certs.${dnsName} = {
    dnsProvider = "cloudflare";
    credentialsFile = config.sops.secrets."cloudflare/cf-dns.env".path;
    dnsPropagationCheck = true;
    extraDomainNames = [ "*.egor.wtf" ];
    # Disable webroot auth method
    webroot = lib.mkForce null;
  };
}
