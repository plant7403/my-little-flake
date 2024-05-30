{pkgs, ...}:{
  imports = [
    ./home.nix
  ]; 
  home.packages = with pkgs; [
    ardour
    guitarix
    drumgizmo
    zynaddsubfx
    geonkick
    artyFX
    gxplugins-lv2
  ];
}