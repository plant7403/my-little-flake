{pkgs, ...}: {
  imports = [
    ./../../common/optional/headscale/tailscale.nix
  ];
  environment.persistence."/persist".directories = [
    "/var/lib/tailscale"
  ];
}
