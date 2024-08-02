{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  # Shorter name to access final settings a
  # user of ts-custom.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.modules.tailscale;
in {
  # Declare what settings a user of this "ts-custom.nix" module CAN SET.
  options.modules.tailscale = {
    enable = mkEnableOption "ts-custom service";
    exit = mkOption {
      type = types.bool;
      default = false;
    };
    impermanence = mkOption {
      type = types.bool;
      default = false;
    };
    hostname = mkOption {
      type = types.str;
      default = "default";
    };
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "ts-custom.nix" module ENABLED this module
  # by setting "services.ts-custom.enable = true;".
  config = mkMerge [
    (mkIf cfg.enable {
      services.tailscale = {
        enable = true;
        useRoutingFeatures =
          if cfg.exit
          then "both"
          else "client";

        extraUpFlags =
          [
            "--login-server https://head.egor.wtf"
            "--hostname=${cfg.hostname}"
            "--operator=egor"
          ]
          ++ mkIf cfg.exit [
            "--advertise-exit-node"
          ];
      };

      networking.firewall = {
        checkReversePath = "loose";
        trustedInterfaces = ["tailscale0"];
        allowedUDPPorts = [config.services.tailscale.port];
      };

      boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

      systemd.services.NetworkManager-wait-online = {
        serviceConfig = {
          ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
        };
      };
    })
    (mkIf cfg.impermanence {
      environment.persistence."/persist".directories = [
        "/var/lib/tailscale"
      ];
    })
    (mkIf cfg.exit {
      services.networkd-dispatcher.enable = true;
      services.networkd-dispatcher.rules = {
        "tailscale-routing" = {
          onState = ["routable" "off"];
          script = ''
            ${lib.getExe pkgs.ethtool} -K enp0s31f6 rx-udp-gro-forwarding on rx-gro-list off
          '';
        };
      };
    })
  ];
}
/*
services.tailscale = {
  enable = true;
  useRoutingFeatures = lib.mkDefault "client";
  extraUpFlags = [
    "--login-server https://head.egor.wtf"
    "--hostname ${cfg.hostname}"
  ];
};

networking.firewall = {
  checkReversePath = "loose";
  trustedInterfaces = ["tailscale0"];
  allowedUDPPorts = [config.services.tailscale.port];
};

boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

systemd.services.NetworkManager-wait-online = {
  serviceConfig = {
    ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
  };
};
*/

