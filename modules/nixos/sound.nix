{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.sound;
in {
  options.modules.sound = {
    enable = mkEnableOption "service";
  };

  config = mkIf cfg.enable {
    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
      #wireplumber.enable = true;
    };
  };
}
