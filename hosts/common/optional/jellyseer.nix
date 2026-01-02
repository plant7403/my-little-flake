{ ... }:
{
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
  /*
       services.jackett = {
      #group = "media";
      enable = true;
      #openFirewall = true;
    };
  */
  services.lidarr = {
    group = "media";
    enable = true;
    #openFirewall = true;
  };
  services.prowlarr = {
    enable = true;
    #openFirewall = true;
  };

  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "seerr";
      upstream = "http://127.0.0.1:5055";
      tor.enable = true;
      tor.authelia = false;
    }
    {
      domain = "egor.wtf";
      prefix = "radarr";
      upstream = "http://127.0.0.1:7878";
      tor.enable = true;
      tor.authelia = false;
      extraConfig = ''
        # Increase timeouts
        send_timeout 100m;
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 30m; '';
    }
    {
      domain = "egor.wtf";
      prefix = "sonarr";
      upstream = "http://127.0.0.1:8989";
      tor.enable = true;
      tor.authelia = false;
      extraConfig = ''
        # Increase timeouts
        send_timeout 100m;
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 30m; '';
    }
    {
      domain = "egor.wtf";
      prefix = "lidarr";
      upstream = "http://127.0.0.1:8686";
      tor.enable = true;
      tor.authelia = false;
    }
    /*
         {
        domain = "egor.wtf";
        prefix = "jackett";
        upstream = "http://127.0.0.1:9117";
        tor.enable = true;
        tor.authelia = false;
      }
    */
    {
      domain = "egor.wtf";
      prefix = "prowlarr";
      upstream = "http://127.0.0.1:9696";
      tor.enable = true;
      tor.authelia = false;
      extraConfig = ''
        # Increase timeouts
        send_timeout 100m;
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 30m; '';
    }
  ];

  users.groups.media = { };

  environment.persistence."/persist".directories = [
    "/var/lib/prowlarr"
    "/var/lib/private/jellyseerr"
    "/var/lib/sonarr"
    "/var/lib/radarr"
    "/var/lib/lidarr"
  ];
  /*
       fileSystems."/var/lib/private/jellyseerr" = {
      device = "/var/lib/jellyseerr";
      options = ["bind"];
    };
  */
}
