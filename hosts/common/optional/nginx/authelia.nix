{config, ...}: {
  # TODO - A lot of fixing needed
  services.authelia.instances.prod = {
    enable = true;
    secrets = {
      jwtSecretFile = config.sops.secrets."services/authelia/jwt".path;
      storageEncryptionKeyFile = config.sops.secrets."services/authelia/storage".path;
      oidcIssuerPrivateKeyFile = config.sops.secrets."services/authelia/oidc/nextcloud/private.pem".path;
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
        default_policy = "two_factor";
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
              "fd7a:115c:a1e0::/48"
              #"fe80::f4b0:1a6c:/64"
              "2001:ee0:41a1:317d::/64"
            ];
          }

          {
            domain = ["*.egor.wtf"];
            policy = "bypass";
            resources = [
              "^/.well-known([/?].*)?$"
            ];
          }
          {
            domain = ["*.egor.wtf"];
            policy = "one_factor";
            subject = "group:users";
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
      regulation = {
        max_retries = 3;
        find_time = 120;
        ban_time = 300;
      };
      authentication_backend = {
        password_reset = {
          disable = false;
        };
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
          #secret = "$pbkdf2-sha512$310000$JPD3TdBJ73D2fW1cSstviQ$3gJsrRXvYW692/3bhYDR1uUJq.2AwFTb/p968LW4w7Y5J.HlxgARXuXdsYd5zrKw3EVKxZn18yEM8kpQYroiIw"; # The digest of 'insecure_secret'.
          secret = "I0BQ4pULuZvwFSiEq4GA3gFr.TpykfZrHC03FMXCQcU4JU6PPvbn2HrnAtOygvAGxrBEC4p-";
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
        {
          id = "Ef~I143cYnw7VJwAz1~nGp-UaGYBT9bOdRssM-69gwg6uqyjSAVT6xOZIPfad6an47UI9amw";
          description = "Headscale";
          #secret = config.sops.secrets."services/authelia/oidc/headscale/client_secret_enc".path;
          secret = "ahQvGBBGnGDu78bFPTRia0Q0BYMvgGOzU-pcODcp2uvxl2-4ylAvLcJj4GNLWTF4-bID~121";
          public = false;
          authorization_policy = "two_factor";
          #require_pkce = true;
          #pkce_challenge_method = "S256";
          #consent_mode = "implicit";
          redirect_uris = [
            "https://head.egor.wtf/a/oauth_response"
            "https://head.egor.wtf/oidc/callback"
            "https://head.egor.wtf/admin/oidc/callback"
          ];
          scopes = [
            "openid"
            "profile"
            "email"
            "groups"
            #"custom"
          ];
          #userinfo_signed_response_alg = "none";
          #token_endpoint_auth_method = "client_secret_post";
        }
      ];

      #identity_providers.oidc = {
      #  jwks = [
      #    {
      #    key_id = "example";
      #    algorithm = "RS256";
      #    use = "sig";
      #    key = config.sops.secrets."services/authelia/oidc/nextcloud/private.pem".path;
      #    }
      #  ];
      #};
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
  #sops.secrets."services/authelia/oidc/headscale/client_id" = {
  #owner = "authelia-prod";
  #};
  #sops.secrets."services/authelia/oidc/headscale/client_secret" = {
  #owner = "authelia-prod";
  #};
  sops.secrets."services/authelia/oidc/headscale/client_secret_enc" = {
    owner = "authelia-prod";
  };

  environment.persistence."/persist".directories = [
    "/var/lib/authelia-prod"
  ];
}
