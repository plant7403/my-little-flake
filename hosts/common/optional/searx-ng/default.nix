{
  pkgs,
  config,
  ...
}:
{
  sops.secrets."services/searx" = { };
  environment.systemPackages = [
    pkgs.searxng
  ];
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    settings = {
      use_default_settings = true;
      engines = [
        {
          name = "duckduckgo";
          engine = "duckduckgo";
          disabled = true;
          #shortcut = "dd";
        }
        {
          name = "qwant";
          disabled = true;
        }
        {
          name = "brave";
          disabled = false;
        }
        {
          name = "yahoo";
          disabled = false;
        }
      ];

      debug = true;
      server.port = 8086;
      server.bind_address = "0.0.0.0";
      server.secret_key = config.sops.secrets."services/searx".path;
    };
    #    runInUwsgi = true;
    #    uwsgiConfig = {
    #      disable-logging = false;
    #      http = ":8086"; # serve via HTTP...
    #      socket = "/run/searx/searx.sock"; # ...or UNIX socket
    #      chmod-socket = "660"; # allow the searx group to read/write to the socket
    #    };
  };

  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "searx";
      upstream = "http://127.0.0.1:8086";
      tor.enable = true;
      tor.authelia = false;
    }
  ];
  sops.secrets."services/searx" = { };
}
