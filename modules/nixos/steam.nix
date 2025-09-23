{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.steam;
in
{
  options.modules.steam = {
    enable = mkEnableOption "service";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # support both 32- and 64-bit applications
      wineWowPackages.stable

      # support 32-bit only
      wine

      # support 64-bit only
      (wine.override { wineBuild = "wine64"; })

      # wine-staging (version with experimental features)
      wineWowPackages.staging

      # winetricks (all versions)
      winetricks

      # native wayland support (unstable)
      wineWowPackages.waylandFull

      protonplus
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    hardware.graphics.enable32Bit = true; # Enables support for 32bit libs that steam uses

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-run"
      ];
    /*
         programs.steam.package = pkgs.steam.override {
        withPrimus = true;
        extraPkgs = pkgs: [bumblebee glxinfo];
      };
    */
  };
}
