_:
{
  virtualHosts."router.egor.wtf" = {
    enableACME = true;
    forceSSL = true;
    extraConfig = ''
      ${builtins.readFile ./../nginx/authelia/vh.conf}
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.1";
      extraConfig = ''
        ${builtins.readFile ./../nginx/authelia/locations.conf}
      '';
    };
  };
}
