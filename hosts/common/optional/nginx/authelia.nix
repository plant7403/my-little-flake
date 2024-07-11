{config, ...}: {
  services.authelia.instances.prod = {
    enable = true;
    secrets = {
      jwtSecretFile = config.sops.secrets."services/authelia/jwt".path;
      storageEncryptionKeyFile = config.sops.secrets."services/authelia/storage".path;
      oidcIssuerPrivateKeyFile = config.sops.secrets."services/authelia/oidc/nextcloud/private.pem".path;
      #oidcHmacSecretFile

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
              "127.0.0.1/24"
              "100.64.0.0/24"
              "192.168.1.0/24"
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
          #{
          #  #domain = ["*.egor.wtf"];
          #  policy = "one_factor";
          #  subject = "group:users";
          #}
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

        # Headscale
        {
          id = "headscale";
          description = "Headscale";
          secret = "$pbkdf2-sha512$310000$bhdup1ycaQmWoLLoFpD/5A$VC1VY6OPD.kOY39FkQR.5wKGWGoASxoQIgB.CXa7WNapC/tLTDOu2wQM6h3pNToXz.Nbu7uQxQIKM8Fp6mfYVA";
          public = false;
          authorization_policy = "two_factor";
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
          ];
        }
      ];
    };
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
  sops.secrets = {
    "services/authelia/jwt".owner = "authelia-prod";
    "services/authelia/storage".owner = "authelia-prod";
    "services/authelia/users.yaml".owner = "authelia-prod";
    "services/authelia/postgres".owner = "authelia-prod";

    "services/authelia/oidc/nextcloud/private.pem".owner = "authelia-prod";
    "services/authelia/oidc/nextcloud/client_id" = {
      owner = config.services.authelia.instances.prod.user;

      #owner = "authelia-prod";
    };
    "services/authelia/oidc/nextcloud/client_secret".owner = "authelia-prod";
    "services/authelia/oidc/nextcloud/client_secret_enc".owner = "authelia-prod";

    "services/authelia/oidc/headscale/client_id".owner = "authelia-prod";
    "services/authelia/oidc/headscale/client_secret".owner = "authelia-prod";
    "services/authelia/oidc/headscale/client_secret_enc".owner = "authelia-prod";
  };

  environment.persistence."/persist".directories = [
    "/var/lib/authelia-prod"
  ];
}
