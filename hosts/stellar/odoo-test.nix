{ pkgs, ... }:
{
  services.odoo = {
    enable = true;
    #package = pkgs.odoo16;
    #addons = [ pkgs.odoo_enterprise ];
    autoInit = true;
    autoInitExtraFlags = [
      "--without-demo=all"
    ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    # other Nginx options
    virtualHosts = {
      "localhost" = {

        /*
          enableACME = true;
               forceSSL = true;
        */
        /*
          extraConfig = ''
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
        */
        locations."/" = {
          proxyPass = "http://127.0.0.1:8069";
          proxyWebsockets = true; # needed if you need to use WebSocket
          /*
            extraConfig = ''
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

              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_cache_bypass $http_upgrade;

                auth_request /authelia;
                auth_request_set $user $upstream_http_remote_user;
                auth_request_set $groups $upstream_http_remote_groups;
                proxy_set_header X-Forwarded-User $user;
                proxy_set_header X-Forwarded-Groups $groups;
                # TODO: Are those needed?
                # auth_request_set $name $upstream_http_remote_name;
                # auth_request_set $email $upstream_http_remote_email;
                # proxy_set_header Remote-Name $name;
                # proxy_set_header Remote-Email $email;
                # TODO: Would be nice to have this working, I think.
                # set $new_cookie $http_cookie;
                # if ($http_cookie ~ "(.*)(?:^|;)\s*example\.com\.session\.id=[^;]+(.*)") {
                #     set $new_cookie $1$2;
                # }
                # proxy_set_header Cookie $new_cookie;

                auth_request_set $redirect $scheme://$http_host$request_uri;
                error_page 401 =302 https://auth.expat.food/?rd=$redirect;
                error_page 403 = https://auth.expat.food/error/403;
            '';
          */
        };
        /*
          locations."/authelia".extraConfig = ''
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

            proxy_set_header Connection "";
            proxy_cache_bypass $cookie_session;
            proxy_no_cache $cookie_session;
            proxy_buffers 4 32k;

            # Advanced Proxy Config
            send_timeout 5m;
            proxy_read_timeout 240;
            proxy_send_timeout 240;
            proxy_connect_timeout 240;
          '';
        */

      };

    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8071
      8072
    ];
    allowedUDPPorts = [
      8071
      8072
    ];

  };

}
