{
  pkgs,
  config,
  ...
}: {
  sops.secrets."services/photoprism/admin/password" = {};
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

  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "photos";
      upstream = "http://127.0.0.1:2342";
      tor.enable = false;
      tor.authelia = false;
    }
  ];
  fileSystems."/var/lib/private/photoprism" = {
    device = "/data/Photos";
    options = ["bind"];
  };
  fileSystems."/var/lib/private/photoprism/import" = {
    device = "/data/Import";
    options = ["bind"];
  };
  #environment.persistence."/persist".directories = [
  #  "/var/lib/private/photoprism"
  #];
}
