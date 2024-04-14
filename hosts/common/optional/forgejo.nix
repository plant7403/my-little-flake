{config, ...}:
# TODO - Built-in SSH
{
  services.nginx.virtualHosts."git.egor.wtf" = {
    enableACME = true;
    forceSSL = true;
    #    locations."/" = {
    #      proxyPass = "http://localhost:3001/";
    #    };
    extraConfig = ''
${builtins.readFile ./nginx/authelia/vh.conf}    
''; #${builtins.readFile ./nginx/authelia/vh.conf}
    locations."/".extraConfig = ''
      include ${config.services.nginx.package}/conf/fastcgi.conf;
      fastcgi_pass unix:${config.services.forgejo.settings.server.HTTP_ADDR};
    ${builtins.readFile ./nginx/authelia/locations.conf}
''; #${builtins.readFile ./nginx/authelia/locations.conf}
  };

  services.forgejo = {
    #package = pkgs.forgejo;
    user = "forgejo";
    group = "forgejo";
    enable = true;
    #appName = "My awesome forgejo server"; # Give the site a name
    lfs = {
      enable = true;
    };
    #useWizard = true;
    database = {
      #user = "forgejo";
      type = "postgres";
      passwordFile = config.sops.secrets."postgres/forgejo".path;
    };
    settings = {
      log.LEVEL = "Debug";
      federation.ENABLED = true;
      server = {
        PROTOCOL = "fcgi+unix";
        ROOT_URL = "https://git.egor.wtf/";
        DISABLE_SSH = false;
        DOMAIN = "git.egor.wtf";
        START_SSH_SERVER = true;
        SSH_PORT = 2222;
      };
      #      httpPort = 3001;
      indexer.REPO_INDEXER_ENABLED = true;
    };
  };

  services.postgresql = {
    ensureDatabases = [config.services.forgejo.user];
    ensureUsers = [
      {
        name = config.services.forgejo.database.user;
        #ensurePermissions."DATABASE ${config.services.forgejo.database.name}" = "ALL PRIVILEGES";
        ensureDBOwnership = true;
      }
    ];
  };

  #systemd.services."forgejo".serviceConfig = lib.mkDefault {
  #  AmbientCapabilities = "CAP_NET_ADMIN";
  #  CapabilityBoundingSet = "CAP_NET_ADMIN";
  #};

  networking.firewall = {
    allowedTCPPorts = [2222];
  };

  services.authelia.instances.prod = {
    settings = {
      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = ["git.egor.wtf"];
            policy = "bypass";
            resources = ["^/me/my-little-flake([/?].*)?$"];
          }
        ];
      };
    };
  };

  sops.secrets."postgres/forgejo" = {
    sopsFile = ./../../../secrets/example.yaml; # bring your own password file
    owner = config.services.forgejo.user;
  };
  environment.persistence."/persist".directories = [
    "/var/lib/forgejo"
  ];
}
