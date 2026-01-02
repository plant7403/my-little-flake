{
  pkgs,
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
    user = "jellyfin";
    group = "media";
  };

  networking = {
    firewall = {
      #allowedTCPPorts = [ 3000 ];
      allowedUDPPorts = [1900 7359];
    };
  };
  /*
  imports = [outputs.nixosModules.web];
  modules.web = {
    enable = true;
    prefix = "jelly";
    port = "8096";
    authelia = true;
    extraConfig = ''
      # required when the target is also TLS server with multiple hosts
      proxy_ssl_server_name on;

      # required when the server wants to use HTTP Authentication
      proxy_pass_header Authorization;
    '';
    tor = {
      enable = true;
      authelia = true;
    };
  };
  */
  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "jelly";
      upstream = "http://127.0.0.1:8096";
      tor = {
        enable = true;
        authelia = false;
      };
    }
  ];

  environment.systemPackages = with pkgs; [
    jellyfin-ffmpeg
  ];
  environment.persistence."/persist".directories = [
    "/var/lib/jellyfin"
  ];
}
