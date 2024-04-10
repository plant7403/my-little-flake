{
  pkgs,
  config,
  ...
}: {
  sops.secrets."services/photoprism/admin/password" = {};
  # FIXME - Change paths so it works with syncthing
  # TODO - Check other similar projects
  services.photoprism = {
    enable = true;
    port = 2342;
    originalsPath = "/var/lib/private/photoprism/originals";
    importPath = "/var/lib/private/photoprism/import";
    address = "0.0.0.0";
    settings = {
      PHOTOPRISM_ADMIN_USER = "egor";
      PHOTOPRISM_ADMIN_PASSWORD = config.sops.secrets."services/photoprism/admin/password".path;
      PHOTOPRISM_DEFAULT_LOCALE = "en";
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = "photoprism";
      PHOTOPRISM_SITE_URL = "https://photos.egor.wtf";
      PHOTOPRISM_SITE_TITLE = "My PhotoPrism";
      PHOTOPRISM_TRACE = "true";
    };
  };
  # MySQL
  services.mysql = {
    enable = true;
    #dataDir = "/data/mysql";
    package = pkgs.mariadb;
    ensureDatabases = ["photoprism"];
    ensureUsers = [
      {
        name = "photoprism";
        ensurePermissions = {"photoprism.*" = "ALL PRIVILEGES";};
      }
    ];
  };
  # NGINX
  services.nginx = {
    enable = true;
    clientMaxBodySize = "500m";
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "photos.egor.wtf" = {
        forceSSL = true;
        enableACME = true;
        http2 = true;
        extraConfig = ''
          ${builtins.readFile ./../nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:2342";
          proxyWebsockets = true;
          extraConfig = ''
            ${builtins.readFile ./../nginx/authelia/locations.conf}
          '';

          #extraConfig = ''
          #            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          #            proxy_set_header Host $host;
          #            proxy_buffering off;
          #proxy_http_version 1.1;
          #          '';
        };
      };
    };
  };
  fileSystems."/var/lib/private/photoprism" = {
    device = "/data/Photos";
    options = ["bind"];
  };
  fileSystems."/var/lib/private/photoprism/import" = {
    device = "/data/Import";
    options = ["bind"];
  };
}
