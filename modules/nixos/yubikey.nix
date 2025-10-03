{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.yubikey;
in
{
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

    security.pam.u2f = {
      enable = true;
      settings = {
        cue = true;
      };
    };

    #security.pam.yubico = {
    #  enable = true;
    #  debug = true;
    #  mode = "challenge-response";
    #  id = ["19271673"];
    #};
    /*
         ACTION=="remove",\
      ENV{ID_BUS}=="usb",\
      ENV{ID_MODEL_ID}=="0407",\
      ENV{ID_VENDOR_ID}=="1050",\
      ENV{ID_VENDOR}=="Yubico",\
    */
    /*
      services.udev.extraRules = ''
        ACTION=="remove",\
        ENV{SUBSYSTEM}=="usb",\
        ENV{PRODUCT}=="1050/407/543",\
        RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
      '';
    */
    #THIS !?

    programs.yubikey-touch-detector.enable = true;
    # security.pam.yubico.control = "required";
  };
}
