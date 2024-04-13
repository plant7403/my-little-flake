{...}: {
  # TODO - General setup, still not working
  services.jellyseerr = {
    openFirewall = true;
    enable = true;
  };
  services.sonarr = {
    group = "media";
    enable = true;
    openFirewall = true;
  };
  services.radarr = {
    group = "media";
    enable = true;
    openFirewall = true;
  };
  services.jackett = {
    group = "media";
    enable = true;
    openFirewall = true;
  };
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    virtualHosts = {
      "seerr.egor.wtf" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          ${builtins.readFile ./nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:5055";
          proxyWebsockets = true;
        };
      };
      "radarr.egor.wtf" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          ${builtins.readFile ./nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:7878";
          proxyWebsockets = true;
        };
      };
      "sonarr.egor.wtf" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          ${builtins.readFile ./nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8989";
          proxyWebsockets = true;
        };
      };
      "jackett.egor.wtf" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          ${builtins.readFile ./nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:9117";
          proxyWebsockets = true;
          extraConfig = ''
            ${builtins.readFile ./nginx/authelia/locations.conf}
          '';
        };
      };
    };
  };

  environment.persistence."/persist".directories = [
    "/var/lib/jackett"
    "/var/lib/private/jellyseer"
    "/var/lib/sonarr"
    "/var/lib/radarr"
  ];
}
