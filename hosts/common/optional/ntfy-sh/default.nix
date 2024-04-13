{...}: {
  # TODO - Make it private
  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = ":8085";
      base-url = "https://push.egor.wtf";
      auth-file = "/var/lib/ntfy-sh/user.db";
      behind-proxy = true;
      #attachment-cache-dir = "/var/cache/ntfy-sh/attachments";
      attachment-total-size-limit = "5G";
      attachment-file-size-limit = "15M";
      #attachment-expiry-duratibase-url;
    };
  };
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    virtualHosts."push.egor.wtf" = {
      enableACME = true;
      forceSSL = true;
      #extraConfig = ''
      # ${builtins.readFile ./../nginx/authelia/vh.conf}
      #'';
      locations."/" = {
        proxyPass = "http://127.0.0.1:8085";
        proxyWebsockets = true;
        # extraConfig = ''
        # ${builtins.readFile ./../nginx/authelia/locations.conf}
        # '';
      };
    };
  };
  environment.persistence."/persist".directories = [
    "/var/lib/private/ntfy-sh"
  ];
}
