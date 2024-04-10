{config, ...}: {
  services.headscale = {
    enable = true;
    port = 8089;
    address = "0.0.0.0";
    settings = {
      dns_config = {
        override_local_dns = true;
        #        base_domain = "private";
        #        magic_dns = true;
        #        domains = ["dns.egor.wtf"];
        nameservers = [
          "100.64.0.1"
        ];
      };
      server_url = "https://head.egor.wtf";
      metrics_listen_addr = "0.0.0.0:8095";
      logtail = {
        enabled = false;
      };
      log = {
        level = "warn";
      };
      ip_prefixes = [
        "100.64.0.0/10"
        "fd7a:115c:a1e0::/48"
      ];
      derp.server = {
        enable = true;
        region_id = 999;
        stun_listen_addr = "0.0.0.0:3478";
      };
    };
  };
  services.nginx = {
    enable = true;
    virtualHosts."head.egor.wtf" = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        ${builtins.readFile ./../nginx/authelia/vh.conf}
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:8089";
        proxyWebsockets = true;
        extraConfig = ''
          ${builtins.readFile ./../nginx/authelia/locations.conf}
        '';
      };
      locations."/metrics" = {
        proxyPass = "http://127.0.0.1:8095";
        proxyWebsockets = true;
        extraConfig = ''
          ${builtins.readFile ./../nginx/authelia/locations.conf}
        '';
      };
    };
  };
  networking.firewall.allowedUDPPorts = [3478];
  environment.systemPackages = [
    config.services.headscale.package
  ];
  services.authelia.instances.prod = {
    settings = {
      access_control = {
        rules = [
          {
            domain = ["cloud.egor.wtf"];
            policy = "bypass";
            resources = ["^/s([/?].*)?$"];
          }
        ];
      };
    };
  };
}
