# FIXME - Fix ipv6 address
## DNS-over-TLS
{ ... }:
{
  networking = {
    interfaces = {
      ens3.ipv6.addresses = [
        {
          address = "2a01:4f8:1c1b:16d0::";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
  };
}
