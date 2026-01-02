{ config, ... }:
{
  sops.secrets."cloudflare/cfdyndns" = { };
  sops.secrets."cloudflare/cf-dns.env" = { };

  services.cloudflare-dyndns = {
    enable = true;
    domains = [ "infra.egor.wtf" ];
    apiTokenFile = config.sops.secrets."cloudflare/cf-dns.env".path;
    ipv6 = true;
  };
  # TODO - Check if any other setup is possible
  #services.cloudflare-dyndns = {
  #  enable = true;
  #  domains = ["egor.wtf"];
  #  apiTokenFile = config.sops.secrets."cloudflare/cf-dns.env".path;
  #  ipv4 = true;
  #  ipv6 = true;
  #  proxied = false;
  #};
}
#services.cloudflare-dyndns.records = [
#  {
#    type = "A";
#    name = cfg.virtualhost;
#    content = "@ip@";
#    proxied = false;
#  }
#];
