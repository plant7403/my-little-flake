# TODO - Same with immortal's default
{
  imports = [
    ./../../common/global/cleanup.nix
    #./../../common/global/hardening.nix
    ./../../common/global/ssh.nix
    #./../../common/optional/headscale/tailscale.nix
    ./../../common/optional/tpm.nix
    ./../../common/optional/virtualization.nix
    ./syncthing.nix
  ];
}
