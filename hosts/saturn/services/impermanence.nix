{...}: {
  imports = [./../../common/global/impermanence/default.nix];
  services.restore-root = {
    enable = true;
    disk = "ssd";
  };
}
