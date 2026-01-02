_:
{
  virtualisation.oci-containers.containers = {
    simplex-smp-server = {
      image = "simplexchat/smp-server:latest";
      ports = [ "5223:5223" ];
      volumes = [
        "/var/lib/containers/simplex/smp/config:/etc/opt/simplex:z"
        "/var/lib/containers/simplex/smp/logs:/var/opt/simplex:z"
      ];
      #cmd = [
      #  "--base-url"
      #  "\"/hackagecompare\""
      #];
      environment = {
        ADDR = "smp.egor.wtf";
        #PASS = config.sops.secrets."services/simplex".path;
      };
    };
    simplex-xftp-server = {
      image = "simplexchat/xftp-server:latest";
      ports = [ "8937:443" ];
      volumes = [
        "/var/lib/containers/simplex/xftp/config:/etc/opt/simplex-xftp:z"
        "/var/lib/containers/simplex/xftp/logs:/var/opt/simplex-xftp:z"
        "/var/lib/containers/simplex/xftp/files:/srv/xftp:z"
      ];
      #cmd = [
      #  "--base-url"
      #  "\"/hackagecompare\""
      #];
      environment = {
        ADDR = "xftp.egor.wtf";
        QUOTA = "1GB";
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      5223
    ];
    allowedUDPPorts = [
      5223
    ];
  };
  environment.persistence."/persist".directories = [
    "/var/lib/containers/simplex/smp/config"
    "/var/lib/containers/simplex/smp/logs"
    "/var/lib/containers/simplex/xftp/config"
    "/var/lib/containers/simplex/xftp/logs"
    "/var/lib/containers/simplex/xftp/files"
  ];
  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "xftp";
      upstream = "http://127.0.0.1:8937";
      authelia = false;
      tor.enable = true;
      tor.authelia = false;
    }
  ];
  services.tor = {
    relay = {
      enable = true;
      role = "relay"; # Set the relay role (e.g., "relay", "bridge")
      onionServices = {
        myOnion = {
          version = 3;
          map = [
            {
              port = 5223;
              target = {
                #addr = "[::1]";
                addr = "127.0.0.1";
                #addr = "https://password.egor.wtf";
                port = 5223;
              };
            }
          ];
        };
      };
    };
  };
  sops.secrets."services/simplex" = { };
}
