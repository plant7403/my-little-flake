{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.ollama;
in
{
  options.modules.ollama = {
    enable = mkEnableOption "service";
    /*
      ollama = mkOption {
        type = types.str;
        default = "default";
      };
    */

  };

  config = mkIf cfg.enable {

    services.ollama = {
      enable = true;
      acceleration = "rocm";
      # Optional: preload models, see https://ollama.com/library
      loadModels = [
        "llama3.2:3b"
        "deepseek-r1:1.8b"
        "gemma3n:e4b"
      ];
      openFirewall = true;
      host = "0.0.0.0";
    };

    environment.systemPackages = [
      (pkgs.ollama.override {
        acceleration = "rocm";
      })
    ];

    services.open-webui = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
    };

    environment.persistence."/persist".directories = [
      "/var/lib/private/ollama"
      "/var/lib/private/open-webui"
    ];
    system.activationScripts."createPersistentStorageDirs".deps = [
      "var-lib-private-permissions"
      "users"
      "groups"
    ];
    system.activationScripts = {
      "var-lib-private-permissions" = {
        deps = [ "specialfs" ];
        text = ''
          mkdir -p /persist/var/lib/private
          chmod 0700 /persist/var/lib/private
        '';
      };
    };
  };
}
