# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  gnome = import ./gnome.nix;
  impermanence = import ./impermanence.nix;
  tailscale = import ./tailscale.nix;
  steam = import ./steam.nix;
  #mullvad = import ./mullvad.nix;
  sound = import ./sound.nix;
  yubikey = import ./yubikey.nix;
  web = import ./nginx.nix;
  transmission = import ./transmission.nix;
  authelia = import ./authelia.nix;
  kde = import ./kde.nix;
  yggdrasil = import ./yggdrasil.nix;
  ollama = import ./ollama.nix;
  xonsh = import ./xonsh.nix;

  system = import ./system/system.nix;
  hardware = import ./system/hardware.nix;
  frameworks = import ./system/frameworks.nix;
}
