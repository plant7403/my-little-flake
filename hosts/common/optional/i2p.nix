{ ... }:
{
  ## I2P Eepsite
  services.i2pd = {
    enable = true;
    ifname = "ens3";
    #address = "xxxx";
    # TCP & UDP
    #port = 9898;
    # TCP
    #ntcp2.port = 9899;
    yggdrasil.enable = true;
    floodfill = true;
    inTunnels = {
      myEep = {
        enable = true;
        #keys = "myEep-keys.dat";
        inPort = 80;
        address = "::1";
        destination = "::1";
        port = 8081;
        # inbound.length = 1;
        # outbound.length = 1;
      };
    };
    enableIPv4 = true;
    enableIPv6 = true;
  };
}
