{...}: {
  services.jellyseerr = {
    #openFirewall = true;
    enable = true;
  };
  services.sonarr = {
    group = "media";
    enable = true;
    #openFirewall = true;
  };
  services.radarr = {
    group = "media";
    enable = true;
    #openFirewall = true;
  };
  services.jackett = {
    #group = "media";
    enable = true;
    #openFirewall = true;
  };
  services.lidarr = {
    group = "media";
    enable = true;
    #openFirewall = true;
  };
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    virtualHosts = {
      "seerr.egor.wtf" = {
        forceSSL = true;
        useACMEHost = "egor.wtf";
        extraConfig = ''
          ${builtins.readFile ./nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:5055";
          proxyWebsockets = true;
          extraConfig = ''
            ${builtins.readFile ./nginx/authelia/locations.conf}
          '';
        };
      };
      "radarr.egor.wtf" = {
        forceSSL = true;
        useACMEHost = "egor.wtf";
        extraConfig = ''
          ${builtins.readFile ./nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:7878";
          proxyWebsockets = true;
          extraConfig = ''
            ${builtins.readFile ./nginx/authelia/locations.conf}
          '';
        };
      };
      "sonarr.egor.wtf" = {
        forceSSL = true;
        useACMEHost = "egor.wtf";
        extraConfig = ''
          ${builtins.readFile ./nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8989";
          proxyWebsockets = true;
          extraConfig = ''
            ${builtins.readFile ./nginx/authelia/locations.conf}
          '';
        };
      };
      "jackett.egor.wtf" = {
        forceSSL = true;
        useACMEHost = "egor.wtf";
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
      "lidarr.egor.wtf" = {
        forceSSL = true;
        useACMEHost = "egor.wtf";
        extraConfig = ''
          ${builtins.readFile ./nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8686";
          proxyWebsockets = true;
          extraConfig = ''
            ${builtins.readFile ./nginx/authelia/locations.conf}
          '';
        };
      };
    };
  };
  users.groups.media = {};

  environment.persistence."/persist".directories = [
    "/var/lib/jackett"
    "/var/lib/jellyseer"
    "/var/lib/sonarr"
    "/var/lib/radarr"
    "/var/lib/lidarr"
  ];
  fileSystems."/var/lib/private/jellyseer" = {
    device = "/var/lib/jellyseer";
    options = ["bind"];
  };
}
