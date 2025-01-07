{config, ...}: {
  services.paperless = {
    enable = false;
    settings = {PAPERLESS_OCR_LANGUAGE = "eng";};
    address = "0.0.0.0";
    port = 28981;
    consumptionDir = "/mnt/share/scanned-documents-copy";
    consumptionDirIsPublic = true;
    passwordFile = config.sops.secrets."services/paperless/admin/password".path;
  };
  sops.secrets."services/paperless/admin/password" = {};

  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "paper";
      upstream = "http://127.0.0.1:28981";
      tor.enable = true;
      tor.authelia = false;
    }
  ];

  environment.persistence."/persist".directories = [
    "/var/lib/paperless"
    "/var/lib/redis-paperless"
  ];
}
