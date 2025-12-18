{
  #inputs,
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
    };
  };

  config = mkIf cfg.enable {
    home.file.".config/Yubico/u2f_keys".source =
      config.lib.file.mkOutOfStoreSymlink
        config.sops.secrets."yubikey".path;

    sops.secrets."yubikey" = {
      # sopsFile = ./secrets.yaml;
    };
    /*
        nix-shell - p pam_u2f
        pamu2fcfg
        sops edit home-manager/secrets.yml
        add the secret
    */
  };
}
