/*
   {
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.web;
in {
  options.modules.web = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    authelia = mkOption {
      type = types.bool;
      default = false;
    };

    prefix = mkOption {
      type = types.str;
      #default = "default";
    };
    domain = mkOption {
      type = types.str;
      default = "egor.wtf";
    };
    port = mkOption {
      type = types.str;
      #default = "default";
    };

    extraConfig = mkOption {
      type = types.lines;
      #default = "default";
    };

    # TORIFY
    tor.enable = mkOption {
      type = types.bool;
      default = false;
    };
    tor.authelia = mkOption {
      type = types.bool;
      default = false;
    };
    tor.onion = mkOption {
      type = types.str;
      default = "ya2rgzzkijougnm32yfq2q6oa3ft6vpxw4j6asufppy5xmae6rucn2yd.onion";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.nginx.virtualHosts = {
        "${cfg.prefix}.${cfg.domain}" = {
          forceSSL = true;
          useACMEHost = "${cfg.domain}";
          extraConfig = ''
          '';
          locations."/" = {
            proxyPass = "http://127.0.0.1:${cfg.port}";
            proxyWebsockets = true;
            extraConfig = ''
              ${cfg.extraConfig}
            '';
          };
        };
      };
    }
    (mkIf cfg.authelia {
      services.nginx.virtualHosts."${cfg.prefix}.${cfg.domain}" = {
        extraConfig = ''
          ${builtins.readFile ../../hosts/common/optional/nginx/authelia/vh.conf}
        '';
        locations."/".extraConfig = ''
          ${builtins.readFile ../../hosts/common/optional/nginx/authelia/locations.conf}
        '';
      };
    })

    (mkIf cfg.tor.enable {
      services.nginx.serverNamesHashBucketSize = 128;
      services.nginx.virtualHosts."${cfg.prefix}.${cfg.tor.onion}" = {
        extraConfig = ''
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:${cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            ${cfg.extraConfig}
          '';
        };
      };
    })
    (mkIf cfg.tor.authelia {
      services.nginx.virtualHosts."${cfg.prefix}.${cfg.tor.onion}" = {
        extraConfig = ''
          ${builtins.readFile ../../hosts/common/optional/nginx/authelia/vh.conf}
        '';
        locations."/".extraConfig = ''
          ${builtins.readFile ../../hosts/common/optional/nginx/authelia/locations.conf}
        '';
      };
    })
  ]);
}
*/
/*
   { config, ... }:
{
  imports = [ ./nginx.nix ];
  config = {
    web.vHosts = [
      {
        // Give values to options defined above
      }
    ];
  };
}
*/
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.web;

  fqdn = c: "${c.prefix}.${c.domain}";
  fqdn_tor = c: "${c.prefix}.${c.tor.onion}";

  vhostConfig = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      prefix = lib.mkOption {
        type = lib.types.str;
        description = "Subdomain which must be protected.";
        example = "subdomain";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain of the subdomain.";
        example = "mydomain.com";
        default = "egor.wtf";
      };
      authelia = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      tor.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      tor.onion = lib.mkOption {
        type = lib.types.str;
        description = "Onion of the subdomain.";
        example = "*.onion";
        default = "ya2rgzzkijougnm32yfq2q6oa3ft6vpxw4j6asufppy5xmae6rucn2yd.onion";
      };
      tor.authelia = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      /*
         ssl = lib.mkOption {
        description = "Path to SSL files";
        type = lib.types.nullOr contracts.ssl.certs;
        default = null;
      };
      */

      upstream = lib.mkOption {
        type = lib.types.str;
        description = "Upstream url to be protected.";
        example = "http://127.0.0.1:1234";
      };
      extraConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        default = null;
      };

      /*
         autheliaRules = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
        description = "Authelia rule configuration";
        example = lib.literalExpression ''          [{
                  policy = "two_factor";
                  subject = ["group:service_user"];
                  }]'';
      };
      */
    };
  };
in {
  options.modules.web = {
    accessLog = lib.mkOption {
      type = lib.types.bool;
      description = "Log all requests";
      default = true;
      example = true;
    };

    debugLog = lib.mkOption {
      type = lib.types.bool;
      description = "Verbose debug of internal. This will print what servers were matched and why.";
      default = false;
      example = true;
    };

    vhosts = lib.mkOption {
      description = "Endpoints to be protected by authelia.";
      type = lib.types.listOf vhostConfig;
      default = [];
    };
  };
  config = {
    networking.firewall.allowedTCPPorts = [80 443];

    services.nginx.enable = true;
    services.nginx.serverNamesHashBucketSize = 128;
    services.nginx.additionalModules = [pkgs.nginxModules.geoip2];
    #services.geoipupdate.enable = true;

    services.nginx.logError = lib.mkIf cfg.debugLog "stderr warn";
    services.nginx.appendHttpConfig = lib.mkIf cfg.accessLog ''
      log_format json_analytics escape=json '{'
                          '"msec": "$msec", ' # request unixtime in seconds with a milliseconds resolution
                          '"connection": "$connection", ' # connection serial number
                          '"connection_requests": "$connection_requests", ' # number of requests made in connection
                          '"pid": "$pid", ' # process pid
                          '"request_id": "$request_id", ' # the unique request id
                          '"request_length": "$request_length", ' # request length (including headers and body)
                          '"remote_addr": "$remote_addr", ' # client IP
                          '"remote_user": "$remote_user", ' # client HTTP username
                          '"remote_port": "$remote_port", ' # client port
                          '"time_local": "$time_local", '
                          '"time_iso8601": "$time_iso8601", ' # local time in the ISO 8601 standard format
                          '"request": "$request", ' # full path no arguments if the request
                          '"request_uri": "$request_uri", ' # full path and arguments if the request
                          '"args": "$args", ' # args
                          '"status": "$status", ' # response status code
                          '"body_bytes_sent": "$body_bytes_sent", ' # the number of body bytes exclude headers sent to a client
                          '"bytes_sent": "$bytes_sent", ' # the number of bytes sent to a client
                          '"http_referer": "$http_referer", ' # HTTP referer
                          '"http_user_agent": "$http_user_agent", ' # user agent
                          '"http_x_forwarded_for": "$http_x_forwarded_for", ' # http_x_forwarded_for
                          '"http_host": "$http_host", ' # the request Host: header
                          '"server_name": "$server_name", ' # the name of the vhost serving the request
                          '"request_time": "$request_time", ' # request processing time in seconds with msec resolution
                          '"upstream": "$upstream_addr", ' # upstream backend server for proxied requests
                          '"upstream_connect_time": "$upstream_connect_time", ' # upstream handshake time incl. TLS
                          '"upstream_header_time": "$upstream_header_time", ' # time spent receiving upstream headers
                          '"upstream_response_time": "$upstream_response_time", ' # time spend receiving upstream body
                          '"upstream_response_length": "$upstream_response_length", ' # upstream response length
                          '"upstream_cache_status": "$upstream_cache_status", ' # cache HIT/MISS where applicable
                          '"ssl_protocol": "$ssl_protocol", ' # TLS protocol
                          '"ssl_cipher": "$ssl_cipher", ' # TLS cipher
                          '"scheme": "$scheme", ' # http or https
                          '"request_method": "$request_method", ' # request method
                          '"server_protocol": "$server_protocol", ' # request protocol, like HTTP/1.1 or HTTP/2.0
                          '"pipe": "$pipe", ' # "p" if request was pipelined, "." otherwise
                          '"gzip_ratio": "$gzip_ratio", '
                          '"http_cf_ray": "$http_cf_ray",'

                          '}';

      access_log /var/log/nginx/access.log json_analytics;
    ''; #'"geoip_country_code": "$geoip_country_code"'

    services.nginx.virtualHosts = let
      vhostCfg = c:
        lib.mkMerge [
          (lib.mkIf c.enable {
            ${fqdn c} = {
              forceSSL = true;
              useACMEHost = "${c.domain}";
              extraConfig =
                ''

                ''
                + lib.optionalString (c.authelia != null) ''
                  # Virtual endpoint created by nginx to forward auth requests.
                  location /authelia {
                    internal;
                    set $upstream_authelia http://127.0.0.1:9091/api/verify;
                    proxy_pass_request_body off;
                    proxy_pass $upstream_authelia;
                    proxy_set_header Content-Length "";

                    # Timeout if the real server is dead
                    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

                    # [REQUIRED] Needed by Authelia to check authorizations of the resource.
                    # Provide either X-Original-URL and X-Forwarded-Proto or
                    # X-Forwarded-Proto, X-Forwarded-Host and X-Forwarded-Uri or both.
                    # Those headers will be used by Authelia to deduce the target url of the     user.
                    # Basic Proxy Config
                    client_body_buffer_size 128k;
                    proxy_set_header Host $host;
                    proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $remote_addr;
                    proxy_set_header X-Forwarded-Proto $scheme;
                    proxy_set_header X-Forwarded-Host $http_host;
                    proxy_set_header X-Forwarded-Uri $request_uri;
                    proxy_set_header X-Forwarded-Ssl on;
                    proxy_redirect  http://  $scheme://;
                    proxy_http_version 1.1;
                    proxy_set_header Connection "";
                    proxy_cache_bypass $cookie_session;
                    proxy_no_cache $cookie_session;
                    proxy_buffers 4 32k;

                    # Advanced Proxy Config
                    send_timeout 5m;
                    proxy_read_timeout 240;
                    proxy_send_timeout 240;
                    proxy_connect_timeout 240;
                  }
                '';

              # Taken from https://github.com/authelia/authelia/issues/178
              locations."/".extraConfig =
                ''
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

                  proxy_pass ${c.upstream};
                ''
                + lib.optionalString c.authelia ''
                  # Basic Authelia Config
                  # Send a subsequent request to Authelia to verify if the user is authenticated
                  # and has the right permissions to access the resource.
                  auth_request /authelia;
                  # Set the `target_url` variable based on the request. It will be used to build the portal
                  # URL with the correct redirection parameter.
                  auth_request_set $target_url $scheme://$http_host$request_uri;
                  # Set the X-Forwarded-User and X-Forwarded-Groups with the headers
                  # returned by Authelia for the backends which can consume them.
                  # This is not safe, as the backend must make sure that they come from the
                  # proxy. In the future, it's gonna be safe to just use OAuth.
                  auth_request_set $user $upstream_http_remote_user;
                  auth_request_set $groups $upstream_http_remote_groups;
                  auth_request_set $name $upstream_http_remote_name;
                  auth_request_set $email $upstream_http_remote_email;
                  proxy_set_header Remote-User $user;
                  proxy_set_header Remote-Groups $groups;
                  proxy_set_header Remote-Name $name;
                  proxy_set_header Remote-Email $email;
                  # If Authelia returns 401, then nginx redirects the user to the login portal.
                  # If it returns 200, then the request pass through to the backend.
                  # For other type of errors, nginx will handle them as usual.
                  error_page 401 =302 https://auth.${c.domain}/?rd=$target_url;
                ''
                + lib.optionalString (c.extraConfig != null) ''
                  ${c.extraConfig}
                '';
            };
          })
          (lib.mkIf c.tor.enable {
            ${fqdn_tor c} = {
              extraConfig =
                ''

                ''
                + lib.optionalString (c.tor.authelia != null) ''
                  # Virtual endpoint created by nginx to forward auth requests.
                  location /authelia {
                    internal;
                    set $upstream_authelia http://127.0.0.1:9091/api/verify;
                    proxy_pass_request_body off;
                    proxy_pass $upstream_authelia;
                    proxy_set_header Content-Length "";

                    # Timeout if the real server is dead
                    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

                    # [REQUIRED] Needed by Authelia to check authorizations of the resource.
                    # Provide either X-Original-URL and X-Forwarded-Proto or
                    # X-Forwarded-Proto, X-Forwarded-Host and X-Forwarded-Uri or both.
                    # Those headers will be used by Authelia to deduce the target url of the     user.
                    # Basic Proxy Config
                    client_body_buffer_size 128k;
                    proxy_set_header Host $host;
                    proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $remote_addr;
                    proxy_set_header X-Forwarded-Proto $scheme;
                    proxy_set_header X-Forwarded-Host $http_host;
                    proxy_set_header X-Forwarded-Uri $request_uri;
                    proxy_set_header X-Forwarded-Ssl on;
                    proxy_redirect  http://  $scheme://;
                    proxy_http_version 1.1;
                    proxy_set_header Connection "";
                    proxy_cache_bypass $cookie_session;
                    proxy_no_cache $cookie_session;
                    proxy_buffers 4 32k;

                    # Advanced Proxy Config
                    send_timeout 5m;
                    proxy_read_timeout 240;
                    proxy_send_timeout 240;
                    proxy_connect_timeout 240;
                  }
                '';

              # Taken from https://github.com/authelia/authelia/issues/178
              locations."/".extraConfig =
                ''
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

                  proxy_pass ${c.upstream};
                ''
                + lib.optionalString c.tor.authelia ''
                  # Basic Authelia Config
                  # Send a subsequent request to Authelia to verify if the user is authenticated
                  # and has the right permissions to access the resource.
                  auth_request /authelia;
                  # Set the `target_url` variable based on the request. It will be used to build the portal
                  # URL with the correct redirection parameter.
                  auth_request_set $target_url $scheme://$http_host$request_uri;
                  # Set the X-Forwarded-User and X-Forwarded-Groups with the headers
                  # returned by Authelia for the backends which can consume them.
                  # This is not safe, as the backend must make sure that they come from the
                  # proxy. In the future, it's gonna be safe to just use OAuth.
                  auth_request_set $user $upstream_http_remote_user;
                  auth_request_set $groups $upstream_http_remote_groups;
                  auth_request_set $name $upstream_http_remote_name;
                  auth_request_set $email $upstream_http_remote_email;
                  proxy_set_header Remote-User $user;
                  proxy_set_header Remote-Groups $groups;
                  proxy_set_header Remote-Name $name;
                  proxy_set_header Remote-Email $email;
                  # If Authelia returns 401, then nginx redirects the user to the login portal.
                  # If it returns 200, then the request pass through to the backend.
                  # For other type of errors, nginx will handle them as usual.
                  error_page 401 =302 http://auth.${c.tor.onion}/?rd=$target_url;
                ''
                + lib.optionalString (c.extraConfig != null) ''
                  ${c.extraConfig}
                '';
            };
          })
        ];
    in
      lib.mkMerge (map vhostCfg cfg.vhosts);
  };
}
