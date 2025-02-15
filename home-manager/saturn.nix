{ pkgs, ... }:
{
  imports = [
    ./home.nix
  ];
  home.packages = with pkgs; [
    #ardour
    guitarix
    godot_4
    flatpak
  ];
}
