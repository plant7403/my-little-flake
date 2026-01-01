{
  config,
  outputs,
  ...
}:

/*
     prefix = "git";
  domain = "egor.wtf";
  onion = "ya2rgzzkijougnm32yfq2q6oa3ft6vpxw4j6asufppy5xmae6rucn2yd.onion";
*/
{
  /*
       imports = [outputs.nixosModules.web];
    modules.web = {
      enable = true;
      prefix = "git";
      port = "5055";
      authelia = true;
      extraConfig = ''

      '';
      tor = {
        enable = true;
        authelia = true;
      };
    };
  */

  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "git";
      upstream = "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}";
      extraConfig = ''
        include ${config.services.nginx.package}/conf/fastcgi.conf;
        fastcgi_pass unix:${config.services.forgejo.settings.server.HTTP_ADDR};
      '';
      tor.enable = true;
      tor.authelia = false;
    }
  ];

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
    ensureDatabases = [ config.services.forgejo.user ];
    ensureUsers = [
      {
        name = config.services.forgejo.database.user;
        ensureDBOwnership = true;
      }
    ];
  };

  #systemd.services."forgejo".serviceConfig = lib.mkDefault {
  #  AmbientCapabilities = "CAP_NET_ADMIN";
  #  CapabilityBoundingSet = "CAP_NET_ADMIN";
  #};

  networking.firewall = {
    allowedTCPPorts = [ 2222 ];
  };

  #services.authelia.instances.prod = {
  #  settings = {
  #    access_control = {
  #      rules = [
  #        {
  #          domain = ["git.egor.wtf"];
  #          policy = "bypass";
  #        }
  #      ];
  #    };
  #  };
  #};
  #config.sops.secrets."postgres/forgejo".path;
  sops.secrets."postgres/forgejo" = {
    sopsFile = ./../../../secrets/common.yaml; # bring your own password file
    owner = config.services.forgejo.user;
  };
  environment.persistence."/persist".directories = [
    "/var/lib/forgejo"
  ];
}
