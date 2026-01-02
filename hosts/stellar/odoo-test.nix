{ ... }:
{
  services.odoo = {
    enable = true;
    #package = pkgs.odoo16;
    #addons = [ pkgs.odoo_enterprise ];
    autoInit = true;
    settings.options = {
      addons_path = "/var/lib/odoo-custom-addons";
    };
    autoInitExtraFlags = [
      "--without-demo=all"
      "-u d2_carousel"
      # "--addons-path=/home/egor/Pak-Unity/CustomAddons"
    ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "localhost" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8069";
          proxyWebsockets = true; # needed if you need to use WebSocket
        };
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
  users.users.egor = {
    extraGroups = [ "odoo" ];
  };
  users.users.odoo = {
    extraGroups = [ "users" ];
  };
}
