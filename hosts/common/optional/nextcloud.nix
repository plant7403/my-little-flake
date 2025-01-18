{
  pkgs,
  config,
  ...
}: {
  sops.secrets."postgres/nextcloud" = {
    owner = "nextcloud";
  };
  sops.secrets."services/nextcloud/admin/password" = {
    owner = "nextcloud"; #config.services.nextcloud.user;
  };

  #services.logrotate.checkConfig = false;
  #  services.onlyoffice = {
  #  enable = true;
  #  hostname = "localhost";
  #};
  services.nextcloud = {
    enable = true;
    #    maxUploadSize = "1G";
    package = pkgs.nextcloud30;
    hostName = "cloud.egor.wtf";
    # Instead of using pkgs.nextcloud27Packages.apps,
    # we'll reference the package version specified above
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit calendar cospend previewgenerator user_oidc; # twofactor_webauthn deck
      #oidc_login = pkgs.fetchNextcloudApp {
      #  sha256 = "sha256:00hraam87v4faj6xxy3kzshkj7rmshky6x9aas8z4a71ak75mpkh";
      #  url = "https://github.com/pulsejet/nextcloud-oidc-login/archive/refs/tags/v3.0.2.tar.gz";
      #  license = "gpl3";
      #};
    };
    extraAppsEnable = true;
    # Enable built-in virtual host management
    # Takes care of somewhat complicated setup
    # See here: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/nextcloud.nix#L529
    #nginx.enable = true;
    settings.enabledPreviewProviders = [
      "OC\\Preview\\BMP"
      "OC\\Preview\\GIF"
      "OC\\Preview\\JPEG"
      "OC\\Preview\\Krita"
      "OC\\Preview\\MarkDown"
      "OC\\Preview\\MP3"
      "OC\\Preview\\OpenDocument"
      "OC\\Preview\\PNG"
      "OC\\Preview\\TXT"
      "OC\\Preview\\XBitmap"
      "OC\\Preview\\HEIC"
      "OC\\Preview\\SVG"
      "OC\\Preview\\DNG"
      "OC\\Preview\\MP4"
      "OC\\Preview\\MOV"
    ];
    settings.overwriteprotocol = "https";
    configureRedis = true;
    caching.apcu = true;

    # Use HTTPS for links
    https = true;

    # Auto-update Nextcloud Apps
    autoUpdateApps.enable = true;
    # Set what time makes sense for you
    autoUpdateApps.startAt = "05:00:00";

    config = {
      # Nextcloud PostegreSQL database configuration, recommended over using SQLite
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";
      dbpassFile = config.sops.secrets."postgres/nextcloud".path;

      adminpassFile = config.sops.secrets."services/nextcloud/admin/password".path;
      adminuser = "me";
    };
  };

  services.postgresql = {
    enable = true;

    # Ensure the database, user, and permissions always exist
    ensureDatabases = ["nextcloud"];
    ensureUsers = [
      {
        name = "nextcloud";
        #ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
        ensureDBOwnership = true;
      }
    ];
  };

  services.nginx.virtualHosts."cloud.egor.wtf" = {
    #enableACME = true;
    forceSSL = true;
    useACMEHost = "egor.wtf";
    extraConfig = ''
      ${builtins.readFile ./nginx/authelia/vh.conf}
    '';
    locations."/" = {
      proxyWebsockets = true;
      extraConfig = ''
        ${builtins.readFile ./nginx/authelia/locations.conf}
      '';
    };
  };

  services.authelia.instances.prod.settings.identity_providers.oidc.clients = [
    {
      id = "nextcloud";
      description = "NextCloud";
      secret = "$pbkdf2-sha512$310000$bhdup1ycaQmWoLLoFpD/5A$VC1VY6OPD.kOY39FkQR.5wKGWGoASxoQIgB.CXa7WNapC/tLTDOu2wQM6h3pNToXz.Nbu7uQxQIKM8Fp6mfYVA";
      public = false;
      authorization_policy = "two_factor";
      #require_pkce = true;
      #pkce_challenge_method = "S256";
      #issuer_private_key = config.sops.secrets."services/authelia/oidc/nextcloud/private.pem".path;
      #consent_mode = "implicit";
      redirect_uris = [
        "https://cloud.egor.wtf/apps/user_oidc/code"
      ];
      scopes = [
        "openid"
        "profile"
        "email"
        "groups"
      ];
      #userinfo_signed_response_alg = "none";
      #token_endpoint_auth_method = "client_secret_post";
    }
  ];
  /*
     modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "cloud";
      upstream = "";
      tor.enable = true;
      tor.authelia = false;
    }
  ];
  */

  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };
  #services.authelia.instances.prod = {
  #  settings = {
  #    access_control = {
  #      rules = [
  #        {
  #          domain = ["cloud.egor.wtf"];
  #          policy = "bypass";
  #          resources = ["^/s([/?].*)?$"];
  #        }
  #      ];
  #    };
  #  };
  #};

  environment.persistence."/persist".directories = [
    "/var/lib/nextcloud"
    #"/var/lib/nextcloud-redis"
    #"/var/lib/redis-nextcloud"
  ];
}
