{config, ...}: {
  # TODO - A lot of fixing needed
  services.authelia.instances.prod = {
    enable = true;
    secrets = {
      jwtSecretFile = config.sops.secrets."services/authelia/jwt".path;
      storageEncryptionKeyFile = config.sops.secrets."services/authelia/storage".path;
    };
    settings = {
      default_2fa_method = "";
      log.level = "info";
      server.host = "0.0.0.0";
      telemetry.metrics.enabled = false;
      theme = "dark";
      webauthn = {
        disable = false;
        display_name = "Authelia";
        attestation_conveyance_preference = "indirect";
        user_verification = "preferred";
        timeout = "60s";
      };
      totp = {
        disable = false;
        issuer = "authelia.com";
        algorithm = "SHA1";
        digits = "6";
        period = "30";
        skew = "1";
        secret_size = "32";
      };
      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = ["auth.egor.wtf"];
            policy = "bypass";
          }
          {
            domain = ["*.egor.wtf" "egor.wtf"];
            policy = "bypass";
            networks = [
              #"internal"
              "100.64.0.0/24"
              "192.168.1.0/24"
              "127.0.0.1/24"
            ];
          }
          #{
          #  domain = ["*.egor.wtf" "egor.wtf" "*.xoxo.green" "xoxo.green"];
          #  resources = [];
          #  policy = "one_factor";
          #}
        ];
      };
      notifier.filesystem = {
        filename = "/var/lib/authelia-prod/notif.txt";
      };
      session.domain = "egor.wtf";
      storage.postgres = {
        host = "/run/postgresql/";
        port = 5432;
        database = "authelia-prod";
        username = "authelia-prod";
        password = config.sops.secrets."services/authelia/postgres".path;
      };
      authentication_backend = {
        file = {
          path = config.sops.secrets."services/authelia/users.yaml".path;
          watch = false;
          search = {
            email = false;
            case_insensitive = false;
          };
          password = {
            algorithm = "argon2";
            argon2 = {
              variant = "argon2id";
              iterations = 3;
              memory = 65536;
              parallelism = 4;
              key_length = 32;
              salt_length = 16;
            };
          };
        };
      };
      identity_providers.oidc.clients = [
        {
          id = "nextcloud";
          description = "NextCloud";
          secret = "$pbkdf2-sha512$310000$c8p78n7pUMln0jzvd4aK4Q$JNRBzwAo0ek5qKn50cFzzvE9RXV88h1wJn5KGiHrD0YKtZaR/nCb2CJPOsKaPK0hjf.9yHxzQGZziziccp6Yng"; # The digest of 'insecure_secret'.
          #public = false;
          authorization_policy = "one_factor";
          #require_pkce = true;
          #pkce_challenge_method = "S256";
          #issuer_private_key = config.sops.secrets."services/authelia/oidc/nextcloud/private.pem".path;
	  redirect_uris = [
            "https://nextcloud.example.com/apps/oidc_login/oidc"
          ];
          scopes = [
            "openid"
            "profile"
            "email"
            "groups"
          ];
          #userinfo_signed_response_alg = "none";
          #token_endpoint_auth_method = "client_secret_basic";
        }
      ];
      identity_providers.oidc = {
      
      };
    };

    # TODO: Change this to currently used user & group
    # user = "";
    # group = "";
    #settingsFiles = {};
    #environmentVariables = {};
  };

  services.postgresql = {
    ensureDatabases = ["authelia-prod"];
    ensureUsers = [
      {
        name = "authelia-prod";
        ensureDBOwnership = true;
      }
    ];
  };

  #services.redis.servers.authelia-main = {
  #  enable = true;
  #  user = "authelia-main";
  #  port = 0;
  #  unixSocket = "/run/redis-authelia-main/redis.sock";
  #  unixSocketPerm = 600;
  #};

  services.nginx.virtualHosts."auth.egor.wtf" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9091";
      proxyWebsockets = true;
    };
  };

  sops.secrets."services/authelia/jwt" = {
    owner = "authelia-prod";
  };
  sops.secrets."services/authelia/storage" = {
    owner = "authelia-prod";
  };
  sops.secrets."services/authelia/users.yaml" = {
    owner = "authelia-prod";
  };
  sops.secrets."system/ip/pluto" = {
    owner = "authelia-prod";
  };
  sops.secrets."services/authelia/postgres" = {
    owner = "authelia-prod";
  };
  sops.secrets."services/authelia/oidc/nextcloud/private.pem" = {
    owner = "authelia-prod";
  };

  environment.persistence."/persist".directories = [
    "/var/lib/authelia-prod"
  ];
}
