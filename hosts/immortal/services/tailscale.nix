{pkgs, ...}: {
  imports = [
    ./../../common/optional/headscale/tailscale-exit.nix
  ];
  environment.persistence."/persist".directories = [
    "/var/lib/tailscale"
  ];
}
