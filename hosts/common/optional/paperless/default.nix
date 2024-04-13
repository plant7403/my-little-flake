{config, ...}: {
  services.paperless = {
    enable = true;
    settings = {PAPERLESS_OCR_LANGUAGE = "eng";};
    address = "0.0.0.0";
    port = 28981;
    consumptionDir = "/mnt/share/scanned-documents-copy";
    consumptionDirIsPublic = true;
    passwordFile = config.sops.secrets."services/paperless/admin/password".path;
  };
  sops.secrets."services/paperless/admin/password" = {};
  services.nginx = {
    enable = true;
    virtualHosts."paper.egor.wtf" = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        ${builtins.readFile ./../nginx/authelia/vh.conf}
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:28981";
        extraConfig = ''
          ${builtins.readFile ./../nginx/authelia/locations.conf}
        '';
      };
    };
  };
}
