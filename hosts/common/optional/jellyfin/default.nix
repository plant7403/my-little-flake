{
  pkgs,
  config,
  ...
}: {
  # 1. enable vaapi on OS-level
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };

  # 2. do not forget to enable jellyfin
  services.jellyfin = {
    enable = true;
    #    user = "jellyfin";
    #    group = "media";
  };

  networking = {
    firewall = {
      #allowedTCPPorts = [ 3000 ];
      allowedUDPPorts = [1900 7359];
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "jelly.egor.wtf" = {
        forceSSL = true;
        useACMEHost = "egor.wtf";
        extraConfig = ''
          ${builtins.readFile ../nginx/authelia/vh.conf}
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
          extraConfig = ''
            ${builtins.readFile ../nginx/authelia/locations.conf}
            # required when the target is also TLS server with multiple hosts
            proxy_ssl_server_name on;

            # required when the server wants to use HTTP Authentication
            proxy_pass_header Authorization;

          '';
        };
      };
    };
  };
  environment.systemPackages = with pkgs; [
    ffmpeg-full
  ];
  environment.persistence."/persist".directories = [
    "/var/lib/jellyfin"
  ];
}
