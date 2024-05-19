{config, ...}: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        # Listening Address
        http_addr = "127.0.0.1";
        # and Port
        http_port = 3000;
        # Grafana needs to know on which domain and URL it's running
        domain = "graf.egor.wtf";
        #root_url = "https://graf.egor.wtf/grafana/"; # Not needed if it is `https://graf.egor.wtf/`
        serve_from_sub_path = true;
      };
    };
  };
  services.nginx.virtualHosts."graf.egor.wtf" = {
    forceSSL = true;
    useACMEHost = "egor.wtf";
    extraConfig = ''
      ${builtins.readFile ./nginx/authelia/vh.conf}
    '';
    locations."/" = {
      proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        ${builtins.readFile ./nginx/authelia/locations.conf}
      '';
    };
  };
  services.prometheus = {
    enable = true;
    port = 9001;
  };

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "immortal";
        static_configs = [
          {
            targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
    ];
  };
}
