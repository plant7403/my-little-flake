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
      # Optional: preload models, see https://ollama.com/library
      loadModels = [
        "codellama:13b"
        "codegemma:7b"
        "gpt-oss:20b"
      ];
      openFirewall = true;
      host = "0.0.0.0";
      acceleration = "rocm";
      /*
        environmentVariables = {
             HCC_AMDGPU_TARGET = "gfx1033"; # used to be necessary, but doesn't seem to anymore
           };
      */
      # results in environment variable "HSA_OVERRIDE_GFX_VERSION=10.3.0"
      rocmOverrideGfx = "10.3.0";
    };

    /*
      environment.systemPackages = [
         (pkgs.ollama.override {
           acceleration = "rocm";
         })
       ];
    */

    services.open-webui = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
      port = 9001;
    };

    environment.persistence."/persist".directories = [
      "/var/lib/private/ollama"
      "/var/lib/private/open-webui"
    ];

  };
}
