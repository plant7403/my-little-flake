{
  inputs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.yubikey-unlock;
in
{
  options = {
    modules.yubikey-unlock = {
      enable = mkEnableOption "service";
      host = mkOption {
        type = types.str;
        default = "default";
      };
    };
  };

  config = {
    home.file.".config/Yubico/u2f_keys".source =
      config.lib.file.mkOutOfStoreSymlink
        config.sops.secrets."users.${config.networking.hostname}.yubikey".path;

    sops.secrets."users/${config.networking.hostname}/yubikey" = {
      sopsFile = ./secrets.yaml;
    };
    /*
        nix-shell - p pam_u2f
        pamu2fcfg
        sops home-manager/secrets.yml
        add the secret
    */
  };
}
