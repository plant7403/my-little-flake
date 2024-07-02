{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.gnome;
in {
  options.modules.gnome = {
    enable = mkEnableOption "service";
    autologin = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.xserver.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
      environment.gnome.excludePackages =
        (with pkgs; [
          gnome-photos
          gnome-tour
          gedit # text editor
        ])
        ++ (with pkgs.gnome; [
          cheese # webcam tool
          gnome-music

          epiphany # web browser
          geary # email reader
          gnome-characters
          tali # poker game
          iagno # go game
          hitori # sudoku game
          atomix # puzzle game
          yelp # Help view
          gnome-contacts
          gnome-initial-setup
        ]);
      programs.dconf.enable = true;
      environment.systemPackages = with pkgs; [
        gnome.gnome-tweaks
      ];
      services.udev.packages = [
        pkgs.gnome.gnome-settings-daemon
      ];
      # Configure keymap in X11
      services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
      };
    })
    (mkIf cfg.autologin {
      # Enable automatic login for the user.
      services.displayManager.autoLogin.enable = true;
      services.displayManager.autoLogin.user = "egor";
      # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;
    })
  ];
}
