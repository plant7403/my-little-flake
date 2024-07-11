{config, ...}: {
  services.headscale = {
    enable = true;
    port = 8089;
    address = "0.0.0.0";
    settings = {
      dns_config = {
        override_local_dns = true;
        base_domain = "head";
        magic_dns = true;
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
        level = "debug";
      };
      ip_prefixes = [
        "100.64.0.0/10"
        "fd7a:115c:a1e0::/48"
      ];
      derp.server = {
        enable = true;
        region_id = 999;
        stun_listen_addr = "0.0.0.0:3478";
        autoUpdate = true;
        updateFrequency = "5m";
      };
      oidc = {
        issuer = "https://auth.egor.wtf";
        client_secret_path = config.sops.secrets."services/authelia/oidc/headscale/client_secret_headscale".path;
        client_id = "headscale";
        #allowed_domains = "egor.wtf";
        #allowed_users = "egor";
        only_start_if_oidc_is_available = true;
        extra_params = {
          domain_hint = "egor.wtf";
        };
        scope = ["openid" "profile" "email" "groups"];
        strip_email_domain = true;
      };
      #db_user = "headscale";
      #db_type = "postgres";
      #db_port = "1234";
      #db_path = "/run/something";
      #db_password_file = config.sops.lalalalal;
      #db_name = "headscale";
      #db_host = "127.0.0.1";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "head.egor.wtf" = {
        forceSSL = true;
        useACMEHost = "egor.wtf";
        extraConfig = ''
          ${builtins.readFile ../nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8089";
          proxyWebsockets = true;
          extraConfig = ''
            ${builtins.readFile ../nginx/authelia/locations.conf}
          '';
        };
        locations."/metrics" = {
          proxyPass = "http://127.0.0.1:8095";
          proxyWebsockets = true;
          extraConfig = ''
            ${builtins.readFile ../nginx/authelia/locations.conf}
          '';
        };
      };
    };
  };

  networking.firewall.allowedUDPPorts = [3478];

  environment.systemPackages = [
    config.services.headscale.package
  ];

  services.authelia.instances.prod.settings.access_control.rules = [
    {
      domain = ["head.egor.wtf"];
      policy = "bypass";
      resources = [
        "^/ts2021([/?].*)?$"
        "^/key([/?].*)?$"
      ];
    }
  ];

  sops.secrets."services/authelia/oidc/headscale/client_id_headscale" = {
    owner = "headscale";
    key = "services/authelia/oidc/headscale/client_id";
  };
  sops.secrets."services/authelia/oidc/headscale/client_secret_headscale" = {
    owner = "headscale";
    key = "services/authelia/oidc/headscale/client_secret";
  };
  #sops.secrets."services/authelia/oidc/headscale/client_secret_enc" = {
  #  owner = "authelia-prod";
  #};

  environment.persistence."/persist".directories = [
    "/var/lib/headscale"
  ];
}
