{ ... }:
{
  imports = [
    ./../../common/global/impermanence/default.nix
    ./../../common/global/impermanence/sops-fix.nix
  ];
  services.restore-root = {
    enable = true;
    disk = "nvme";
  };
}
