{
  pkgs,
  inputs,
  ...
}: {
  services.wordpress.sites."xoxo.green" = {
    themes = {
      inherit
        (pkgs.wordpressPackages.themes)
        twentytwentythree
        ;
    };
    plugins = {
      inherit
        (pkgs.wordpressPackages.plugins)
        antispam-bee
        woocommerce
        vietqr
        woocommerce-pos
        opengraph
        static-mail-sender-configurator
        wordpress-seo
        webp-express
        jetpack
        merge-minify-refresh
        disable-xml-rpc
        simple-login-captcha
        best-woocommerce-feed
        two-factor
        #litcommerce
        
        #quan-ly-cua-hang-telpos
        
        #multisite-language-switcher
        
        nginx-helper
        #translatepress-multilingual
        
        #simple-tags
        
        #internal-links
        
        auto-tag-links
        ;
    };
    virtualHost = {
      enableACME = true;
      forceSSL = true;
      listen."*".ssl = true;
    };
    #languages = [ pkgs.wordpressPackages.languages.de_DE ];
    settings = {
      # Needed to run behind reverse proxy
      FORCE_SSL_ADMIN = true;
      #    WP_ALLOW_MULTISITE = true;
      #    MULTISITE = true;
      #SUBDOMAIN_INSTALL= true;
      #DOMAIN_CURRENT_SITE= "xoxo.green";
      #PATH_CURRENT_SITE= "/";
      #SITE_ID_CURRENT_SITE= 1;
      #BLOG_ID_CURRENT_SITE= 1;
      #WP_ALLOW_REPAIR= true;
    };
    extraConfig = ''
      $_SERVER['HTTPS']='on';
    '';
  };
  services.wordpress.webserver = "nginx";

  nixpkgs.overlays = [
    (_self: super: {
      wordpress = super.wordpress.overrideAttrs (oldAttrs: rec {
        installPhase =
          oldAttrs.installPhase
          + ''
            ln -s /var/lib/wordpress/xoxo.green/webp-express $out/share/wordpress/wp-content/webp-express
          '';
      });
    })
    (_self: super: {
      wordpress = super.wordpress.overrideAttrs (oldAttrs: rec {
        installPhase =
          oldAttrs.installPhase
          + ''
            ln -s /var/lib/wordpress/xoxo.green/mmr $out/share/wordpress/wp-content/mmr
          '';
      });
    })
    (_self: _super: {
      wordpressPackages = pkgs.callPackage inputs.wp4nix {};
    })
  ];

  systemd.tmpfiles.rules = [
    "d '/var/lib/wordpress/xoxo.green/webp-express' 0750 wordpress nginx - -"
    "d '/var/lib/wordpress/xoxo.green/mmr' 0750 wordpress nginx - -"
  ];

  services.nginx = {
    enable = true;
    virtualHosts."xoxo.green" = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        ${builtins.readFile ./../nginx/authelia/vh.conf}
      '';
      locations."/" = {
        extraConfig = ''
          ${builtins.readFile ./../nginx/authelia/locations.conf}
        '';
      };
    };
  };
}
