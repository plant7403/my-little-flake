{...}: {
  # TODO - Check if it's working, and test for the use again
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
