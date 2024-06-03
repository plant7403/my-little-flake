{...}: {
  services.dolibarr = {
    enable = true;
    domain = "doli.egor.wtf";
    nginx = {
      forceSSL = true;
      enableACME = true;
      #listen.*.ssl = true;
      #addSSL = true;
      #listen.*.port = 443;
    };
  };
}
