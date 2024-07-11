{...}: {
  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    config = {
      DOMAIN = "https://password.egor.wtf";
      SIGNUPS_ALLOWED = true;
      DATABASE_URL = "postgresql://vaultwarden@localhost/vaultwarden";
    };
  };
  services.postgresql = {
    authentication = ''
      # TYPE  DATABASE USER CIDR-ADDRESS METHOD
        local all      all               trust
        host  all      all  samehost     trust
    '';
    enable = true;
    ensureDatabases = ["vaultwarden"];
    ensureUsers = [
      {
        name = "vaultwarden";
        #ensurePermissions = {"DATABASE vaultwarden" = "ALL PRIVILEGES";};
        ensureDBOwnership = true;
      }
    ];
  };
  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;

    virtualHosts."password.egor.wtf" = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        ${builtins.readFile ./../nginx/authelia/vh.conf}
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
        extraConfig = ''
          ${builtins.readFile ./../nginx/authelia/locations.conf}
        '';
      };
    };
  };
  services.authelia.instances.prod = {
    settings = {
      access_control = {
        rules = [
          {
            domain = ["password.egor.wtf"];
            policy = "one_factor";
          }
          {
            domain = ["password.egor.wtf"];
            policy = "bypass";
            networks = [
              #"internal"
              "127.0.0.1/24"
              "100.64.0.0/24"
              "192.168.1.0/24"
              "fd7a:115c:a1e0::/48"
              #"fe80::f4b0:1a6c:/64"
              "2001:ee0:41a1:317d::/64"
            ];
          }
        ];
      };
    };
  };

  environment.persistence."/persist".directories = [
    "/var/lib/bitwarden_rs"
  ];
}
