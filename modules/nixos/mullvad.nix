{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.mullvad;
in
{
  options.modules.mullvad = {
    enable = mkEnableOption "service";
    impermanence = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
    })
    (mkIf cfg.impermanence {
      environment.persistence."/persist".directories = [
        "/etc/mullvad-vpn"
      ];
    })
  ];
}
