{...}: {
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      server_host = "::1";
      trusted_proxies = ["::1"];
      use_x_forwarded_for = true;
      default_config = {};
    };
  };
  services.nginx = {
    recommendedProxySettings = true;
    virtualHosts."home.egor.wtf" = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        ${builtins.readFile ./../nginx/authelia/vh.conf}
        proxy_buffering off;
      '';
      locations."/" = {
        proxyPass = "http://[::1]:8123";
        proxyWebsockets = true;
        extraConfig = ''
          ${builtins.readFile ./../nginx/authelia/locations.conf}
        '';
      };
    };
  };
}
