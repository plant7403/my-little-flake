{
  pkgs,
  lib,
  ...
}: {
  #imports=[
  #./options.nix
  #];
  #services.geoipupdate.enable = true;
  #services.geoipupdate.settings = {
  #  EditionIDs = [
  #    "GeoLite2-ASN"
  #    "GeoLite2-City"
  #    "GeoLite2-Country"
  #  ];
  #  AccountID = 995265;
  #  LicenseKey = {
  #    _secret = "/run/secrets/geoip/key";
  #  };
  #};
  services.nginx = {
    enable = true;
    virtualHosts."errors.egor.wtf" = {
      root = "${./error_page}";
    };
    statusPage = true;
    # TODO - Review defaults
    recommendedZstdSettings = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;
    /*
       appendHttpConfig = let
      internal = "https://errors.egor.wtf";
    in ''
      location * {
        # ERROR_PAGE
        error_page 400 ${internal}/400.html
        error_page 401 ${internal}/401.html
        error_page 402 ${internal}/402.html
        error_page 403 ${internal}/403.html
        error_page 404 ${internal}/404.html
        error_page 405 ${internal}/405.html
        error_page 406 ${internal}/406.html
        error_page 407 ${internal}/407.html
        error_page 408 ${internal}/408.html
        error_page 409 ${internal}/409.html
        error_page 410 ${internal}/410.html
        error_page 411 ${internal}/411.html
        error_page 412 ${internal}/412.html
        error_page 413 ${internal}/413.html
        error_page 414 ${internal}/414.html
        error_page 415 ${internal}/415.html
        error_page 416 ${internal}/416.html
        error_page 417 ${internal}/417.html
        error_page 418 ${internal}/418.html
        error_page 421 ${internal}/421.html
        error_page 422 ${internal}/422.html
        error_page 423 ${internal}/423.html
        error_page 424 ${internal}/424.html
        error_page 425 ${internal}/425.html
        error_page 426 ${internal}/426.html
        error_page 428 ${internal}/428.html
        error_page 429 ${internal}/429.html
        error_page 431 ${internal}/431.html
        error_page 451 ${internal}/451.html
        error_page 500 ${internal}/500.html
        error_page 501 ${internal}/501.html
        error_page 502 ${internal}/502.html
        error_page 503 ${internal}/503.html
        error_page 504 ${internal}/504.html
        error_page 505 ${internal}/505.html
        error_page 506 ${internal}/506.html
        error_page 507 ${internal}/507.html
        error_page 508 ${internal}/508.html
        error_page 510 ${internal}/510.html
        error_page 511 ${internal}/511.html
        }
    '';
    */
    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
    commonHttpConfig = let
      realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
      fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
      cfipv4 = fileToList (pkgs.fetchurl {
        url = "https://www.cloudflare.com/ips-v4";
        sha256 = "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
      });
      cfipv6 = fileToList (pkgs.fetchurl {
        url = "https://www.cloudflare.com/ips-v6";
        sha256 = "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
      });
      # TODO - Check all the parameters + review cf
    in ''
            #cloudflare real ip
            ${realIpsFromList cfipv4}
            ${realIpsFromList cfipv6}
            real_ip_header CF-Connecting-IP;

            # Add HSTS header with preloading to HTTPS requests.
            # Adding this header to HTTP requests is discouraged
            map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains; preload";
            }
            #add_header Strict-Transport-Security $hsts_header;

            # Enable CSP for your services.
            #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

            # Minimize information leaked to other domains
      #      add_header 'Referrer-Policy' 'origin-when-cross-origin';

            # Disable embedding as a frame
      #      add_header X-Frame-Options DENY;

            # Prevent injection of code in other mime types (XSS Attacks)
      #      add_header X-Content-Type-Options nosniff;

            # Enable XSS protection of the browser.
            # May be unnecessary when CSP is configured properly (see above)
      #      add_header X-XSS-Protection "1; mode=block";
            # This might create errors
      #      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";

    '';
    virtualHosts."_".locations."/".return = "404";
    virtualHosts."*.egor.wtf".extraConfig = ''
      error_page 400 https://errors.egor.wtf/400.html;
      error_page 401 https://errors.egor.wtf/401.html;
      error_page 402 https://errors.egor.wtf/402.html;
      error_page 403 https://errors.egor.wtf/403.html;
      error_page 404 https://errors.egor.wtf/404.html;
      error_page 405 https://errors.egor.wtf/405.html;
      error_page 406 https://errors.egor.wtf/406.html;
      error_page 407 https://errors.egor.wtf/407.html;
      error_page 408 https://errors.egor.wtf/408.html;
      error_page 409 https://errors.egor.wtf/409.html;
      error_page 410 https://errors.egor.wtf/410.html;
      error_page 411 https://errors.egor.wtf/411.html;
      error_page 412 https://errors.egor.wtf/412.html;
      error_page 413 https://errors.egor.wtf/413.html;
      error_page 414 https://errors.egor.wtf/414.html;
      error_page 415 https://errors.egor.wtf/415.html;
      error_page 416 https://errors.egor.wtf/416.html;
      error_page 417 https://errors.egor.wtf/417.html;
      error_page 418 https://errors.egor.wtf/418.html;
      error_page 421 https://errors.egor.wtf/421.html;
      error_page 422 https://errors.egor.wtf/422.html;
      error_page 423 https://errors.egor.wtf/423.html;
      error_page 424 https://errors.egor.wtf/424.html;
      error_page 425 https://errors.egor.wtf/425.html;
      error_page 426 https://errors.egor.wtf/426.html;
      error_page 428 https://errors.egor.wtf/428.html;
      error_page 429 https://errors.egor.wtf/429.html;
      error_page 431 https://errors.egor.wtf/431.html;
      error_page 451 https://errors.egor.wtf/451.html;
      error_page 500 https://errors.egor.wtf/500.html;
      error_page 501 https://errors.egor.wtf/501.html;
      error_page 502 https://errors.egor.wtf/502.html;
      error_page 503 https://errors.egor.wtf/503.html;
      error_page 504 https://errors.egor.wtf/504.html;
      error_page 505 https://errors.egor.wtf/505.html;
      error_page 506 https://errors.egor.wtf/506.html;
      error_page 507 https://errors.egor.wtf/507.html;
      error_page 508 https://errors.egor.wtf/508.html;
      error_page 510 https://errors.egor.wtf/510.html;
      error_page 511 https://errors.egor.wtf/511.html;
    '';
  };
  # This is needed for nginx to be able to read other processes
  # directories in `/run`. Else it will fail with (13: Permission denied)
  #systemd.services.nginx.serviceConfig.ProtectHome = false;
  security.acme = {
    acceptTerms = true;
    defaults.email = "ssl@egor.wtf";
  };

  environment.persistence."/persist" = {
    directories = ["/var/lib/acme"];
  };

  networking.firewall = {
    allowedTCPPorts = [80 443];
  };
}
