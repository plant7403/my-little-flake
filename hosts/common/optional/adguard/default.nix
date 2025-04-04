{ config, outputs, ... }:
{
  #config.sops.secrets."postgres/forgejo".path;
  #sops.secrets."postgres/forgejo" = {
  #  sopsFile = ./../../../secrets/example.yaml; # bring your own password file
  #  owner = config.services.forgejo.user;
  #};
  sops.secrets."services/adguard-home/admin/password" = { };

  networking = {
    firewall = {
      allowedTCPPorts = [ 853 ];
      allowedUDPPorts = [
        53
        853
      ];
    };
  };

  services = {
    adguardhome = {
      enable = true;
      port = 3050;
      host = "0.0.0.0";
      openFirewall = true;
      mutableSettings = false;
      settings = {
        schema_version = 28;
        upstream_dns = "127.0.0.1:5335";
        cache_optimistic = true;
        enable_dnssec = true;
        dns = {
          bind_host = "0.0.0.0";
          bootstrap_dns = [
            "9.9.9.10"
            "1.1.1.1"
          ];
        };
        users = [
          {
            name = "egor";
            #password = "${toString config.sops.secrets."services/adguard-home/admin/password".path}"; #BCrypt
            password = "$2b$05$7W7JIo5H5.T9kqf/5ZIkvurtzJd85k0c8wNduJGmHOqxi.ZvHi6KG";
          }
        ];
        tls = {
          enabled = true;
          server_name = "dns.egor.wtf";
          allow_unencrypted_doh = true;
          certificate_path = "/var/lib/acme/dns.egor.wtf/fullchain.pem";
          private_key_path = "/var/lib/acme/dns.egor.wtf/key.pem";
          port_https = 0;
        };
        safe_search = {
          enabled = false;
        };
        user_rules = [
          "||egor.wtf^$client=192.168.1.0/24,dnsrewrite=NOERROR;A;192.168.1.18"
          "||*.egor.wtf^$client=192.168.1.0/24,dnsrewrite=NOERROR;A;192.168.1.18"
          "||*.*.egor.wtf^$client=192.168.1.0/24,dnsrewrite=NOERROR;A;192.168.1.18"
          #"@@||mail.egor.wtf^$client=192.168.1.0/24"
          "||egor.wtf^$client=127.0.0.1,dnsrewrite=NOERROR;A;127.0.0.1"
          "||*.egor.wtf^$client=127.0.0.1,dnsrewrite=NOERROR;A;127.0.0.1"
          "||*.*.egor.wtf^$client=127.0.0.1,dnsrewrite=NOERROR;A;127.0.0.1"
          "||egor.wtf^$client=100.64.0.0/24,dnsrewrite=NOERROR;A;100.64.0.1"
          "||*.egor.wtf^$client=100.64.0.0/24,dnsrewrite=NOERROR;A;100.64.0.1"
          "||*.*.egor.wtf^$client=100.64.0.0/24,dnsrewrite=NOERROR;A;100.64.0.1"
          #"||mail.egor.wtf^$client=100.64.0.0/24,dnsrewrite=NOERROR;A;100.64.0.5"
        ];
      };
    };
  };
  /*
    services.nginx = {
      enable = true;
      virtualHosts."dns.egor.wtf" = {
        extraConfig = ''
          ${builtins.readFile ./../nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:3050";
          extraConfig = ''
            ${builtins.readFile ./../nginx/authelia/locations.conf}
          '';
        };

        # FIXME - This doesn't make much sense
        locations."/dns-query" = {
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_bind 127.0.0.1;
          '';
        };
      };
    };
  */
  imports = [ outputs.nixosModules.web ];
  modules.web = {
    vhosts = [
      {
        domain = "egor.wtf";
        prefix = "dns";
        upstream = "http://127.0.0.1:3050";
        tor.enable = true;
        tor.authelia = false;
      }
    ];
  };

  systemd.services."kresd@1" = {
    enable = false;
  };
  services.authelia.instances.prod = {
    settings = {
      access_control = {
        rules = [
          {
            domain = [ "dns.egor.wtf" ];
            policy = "bypass";
            #resources = ["^/s([/?].*)?$"];
          }
        ];
      };
    };
  };
  environment.persistence."/persist".directories = [
    "/var/lib/private/AdGuardHome"
  ];
}
