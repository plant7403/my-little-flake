{config, ...}: {
  sops.secrets."cloudflare/cfdyndns" = {};
  sops.secrets."cloudflare/cf-dns.env" = {};

  services.cfdyndns = {
    enable = true;
    records = ["jelly.egor.wtf" "git.egor.wtf" "head.egor.wtf" "smp.egor.wtf" "xftp.egor.wtf"];
    apiTokenFile = config.sops.secrets."cloudflare/cfdyndns".path;
  };
  # TODO - Check if any other setup is possible
  services.cloudflare-dyndns = {
    enable = true;
    domains = ["egor.wtf"];
    apiTokenFile = config.sops.secrets."cloudflare/cf-dns.env".path;
    ipv4 = true;
    ipv6 = true;
    proxied = true;
  };
}
#services.cloudflare-dyndns.records = [
#  {
#    type = "A";
#    name = cfg.virtualhost;
#    content = "@ip@";
#    proxied = false;
#  }
#];

