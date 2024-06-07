{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.yubikey;
in {
  options.modules.yubikey = {
    enable = mkEnableOption "service";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [
      pkgs.yubikey-personalization
      pkgs.yubikey-touch-detector
    ];
    programs.dconf.enable = true;
    services.pcscd.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
