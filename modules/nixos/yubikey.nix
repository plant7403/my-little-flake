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
    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      #login.yubicoAuth = true;
      #sudo.yubicoAuth = true;
    };
    #security.pam.yubico = {
    #  enable = true;
    #  debug = true;
    #  mode = "challenge-response";
    #  id = ["19271673"];
    #};
    services.udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="0407",\
       ENV{ID_VENDOR_ID}=="1050",\
       ENV{ID_VENDOR}=="Yubico",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';

    # security.pam.yubico.control = "required";
  };
}
