{ pkgs, ... }:
{
  imports = [
    ./easyeffects.nix
    ./extensions.nix
    ./firefox.nix
    ./vscode.nix
    ./ghostty.nix
    ./obsidian.nix
    ./chromium.nix
  ];
  home.packages = with pkgs; [
    dnsutils
    gonzo
  ];
}
