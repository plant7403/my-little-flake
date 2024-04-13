{ ...}: {
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
      #extraConfig = ''
      #  ${builtins.readFile ./../nginx/authelia/vh.conf}
      #'';
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
       # extraConfig = ''
       #   ${builtins.readFile ./../nginx/authelia/locations.conf}
       # '';
      };
    };
  };
}
