{}:
with lib; let
  cfg = config.modules.<name>;
  in {
  options.modules.<name> = {
  enable = mkEnableOption "service";
  <name> = mkOption {
  type = types.str;
  default = "default";
  };

  };

  config = mkIf cfg.enable { };
  }
