{...}: {
  # TODO - Look into it, the original setup was brief
  services.unbound = {
    enable = true;

    settings = {
      server = {
        interface = ["127.0.0.1"];
        statistics-interval = "30";
        port = 5335;
      };
      #      forward-zone = [
      #        {
      #          name = ".";
      #          forward-addr = "1.1.1.1@853#cloudflare-dns.com";
      #        }
      #        {
      #          name = "example.org.";
      #          forward-addr = [
      #            "1.1.1.1@853#cloudflare-dns.com"
      #            "1.0.0.1@853#cloudflare-dns.com"
      #          ];
      #        }
      #      ];
      #      remote-control.control-enable = true;
    };
  };
}
