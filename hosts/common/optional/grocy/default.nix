_:
{
  services.grocy = {
    enable = true;
    hostName = "grocy.egor.wtf";
    settings = {
      culture = "en";
      currency = "vnd";
    };
    nginx.enableSSL = true;
  };
  #services.nginx.virtualHosts."grocy.egor.wtf".locations."~ \\.(js|css|ttf|woff2?|png|jpe?g|svg)$".extraConfig = ''
  #add_header X-Frame-Options DENY;
  #'';
}
