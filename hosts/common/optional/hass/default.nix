{ ... }:
{
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
      trusted_proxies = [ "::1" ];
      use_x_forwarded_for = true;
      default_config = { };
    };
  };

  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "home";
      upstream = "http://127.0.0.1:8123";
      tor.enable = false;
      tor.authelia = true;
      extraConfig = ''
        proxy_buffering off;
      '';
    }
  ];
}
