{outputs, ...}: {
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
        ensureDBOwnership = true;
      }
    ];
  };
  /*
  imports = [outputs.nixosModules.web];
  modules.web = {
    enable = true;
    prefix = "password";
    port = "8000";
    authelia = true;
    tor = {
      enable = true;
      authelia = true;
    };
  };
  */
  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "password";
      upstream = "http://127.0.0.1:8000";
    }
  ];

  services.authelia.instances.prod = {
    settings = {
      access_control = {
        rules = [
          /*
             {
            domain = ["password.egor.wtf"];
            policy = "one_factor";
          }
          */
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
