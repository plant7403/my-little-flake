{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.authelia;
in
{
  options.modules.authelia = {
    enable = lib.mkEnableOption "service";
  };
  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/authelia/jwt".owner = "authelia-prod";
      "services/authelia/storage".owner = "authelia-prod";
      "services/authelia/users.yaml".owner = "authelia-prod";
      "services/authelia/postgres".owner = "authelia-prod";

      "services/authelia/oidc/nextcloud/private.pem".owner = "authelia-prod";
      "services/authelia/oidc/nextcloud/client_id" = {
        #owner = config.services.authelia.instances.prod.user;

        owner = "authelia-prod";
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

    services.authelia.instances = {
      prod = {
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
          server.address = "tcp://:9091/";
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
                domain = [ "auth.egor.wtf" ];
                policy = "bypass";
              }
              {
                domain = [
                  "*.egor.wtf"
                  "egor.wtf"
                ];
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
                domain = [ "*.egor.wtf" ];
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
              inherit (config.sops.secrets."services/authelia/users.yaml") path;
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
        };
      };
    };

    services.nginx.virtualHosts."auth.egor.wtf" = {
      # Taken from https://github.com/authelia/authelia/issues/178
      # TODO: merge with config from https://matwick.ca/authelia-nginx-sso/
      locations."/".extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Robots-Tag "noindex, nofollow, nosnippet, noarchive";
        add_header X-Download-Options noopen;
        add_header X-Permitted-Cross-Domain-Policies none;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_cache_bypass $http_upgrade;

        proxy_pass http://127.0.0.1:9091;
        proxy_intercept_errors on;
        if ($request_method !~ ^(POST)$){
            error_page 401 = /error/401;
            error_page 403 = /error/403;
            error_page 404 = /error/404;
        }
      '';

      locations."/api/verify".extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Robots-Tag "noindex, nofollow, nosnippet, noarchive";
        add_header X-Download-Options noopen;
        add_header X-Permitted-Cross-Domain-Policies none;

        proxy_set_header Host $http_x_forwarded_host;
        proxy_pass http://127.0.0.1:9091;
      '';
    };
    services.nginx.virtualHosts."auth.egorwtfz6xxh2qatvpcjodxdo33nlesc5dp7lhqohbackq5rnpvpsqyd.onion" =
      {
        # Taken from https://github.com/authelia/authelia/issues/178
        # TODO: merge with config from https://matwick.ca/authelia-nginx-sso/
        locations."/".extraConfig = ''
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
          add_header X-Content-Type-Options nosniff;
          add_header X-Frame-Options "SAMEORIGIN";
          add_header X-XSS-Protection "1; mode=block";
          add_header X-Robots-Tag "noindex, nofollow, nosnippet, noarchive";
          add_header X-Download-Options noopen;
          add_header X-Permitted-Cross-Domain-Policies none;

          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_cache_bypass $http_upgrade;

          proxy_pass http://127.0.0.1:9092;
          proxy_intercept_errors on;
          if ($request_method !~ ^(POST)$){
              error_page 401 = /error/401;
              error_page 403 = /error/403;
              error_page 404 = /error/404;
          }
        '';

        locations."/api/verify".extraConfig = ''
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
          add_header X-Content-Type-Options nosniff;
          add_header X-Frame-Options "SAMEORIGIN";
          add_header X-XSS-Protection "1; mode=block";
          add_header X-Robots-Tag "noindex, nofollow, nosnippet, noarchive";
          add_header X-Download-Options noopen;
          add_header X-Permitted-Cross-Domain-Policies none;

          proxy_set_header Host $http_x_forwarded_host;
          proxy_pass http://127.0.0.1:9092;
        '';
      };

  };
}
