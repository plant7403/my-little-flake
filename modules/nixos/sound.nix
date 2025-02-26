{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.sound;
in
{
  options.modules.sound = {
    enable = mkEnableOption "service";
  };

  config = mkIf cfg.enable {
    # Remove sound.enable or set it to false if you had it set previously, as sound.enable is only meant for ALSA-based configurations

    # rtkit is optional but recommended
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
    };
    services.pulseaudio.enable = false;
    #services.pipewire.package = pkgs.pipewire.override {libcameraSupport = false;};
    #/*

  };
}
