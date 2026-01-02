{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    (_self: _super: {
      wordpressPackages = pkgs.callPackage inputs.wp4nix { };
    })
  ];
}
# Libressl
#(final: super: {
#  nginxStable = super.nginxStable.override { openssl = super.pkgs.libressl; };
#})
