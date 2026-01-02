_:
{
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

  /*
       imports = [outputs.nixosModules.web];
    modules.web = {
      enable = true;
      prefix = "push";
      port = "8085";
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
      prefix = "push";
      upstream = "http://127.0.0.1:8085";
    }
  ];
  environment.persistence."/persist".directories = [
    "/var/lib/private/ntfy-sh"
  ];
}
