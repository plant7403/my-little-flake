{ lib, ... }:
{
  # TODO - It's actually off
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        config.forceSSL = lib.mkDefault true;
      }
    );
  };
}
