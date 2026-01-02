{ inputs, lib }:
with lib;
{
  config = mkMerge [
    {
      nix = {
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
        settings = {
          experimental-features = [
            "flakes"
            "nix-command"
          ];
          trusted-users = mkDefault [
            "root"
            "@wheel"
          ];
          allowed-users = mkDefault [
            "root"
            "@wheel"
          ];
          always-allow-substitutes = true;
          substituters = lib.mkBefore [
            "https://install.determinate.systems"
            "https://nix-community.cachix.org"
            "https://viperml.cachix.org"
            "https://nixpkgs-unfree.cachix.org"
            "https://ghostty.cachix.org"
          ];

          trusted-public-keys = [
            "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
            "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
            "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
          ];
          auto-optimise-store = true;
          max-jobs = "auto";
          cores = 0;
          connect-timeout = 5;
          commit-lockfile-summary = "Update flake.lock";
          keep-outputs = true;
          keep-derivations = true;
          warn-dirty = false;
          keep-going = true;
          log-lines = 20;
          download-buffer-size = mkIf (nix.package != pkgs.lixPackageSets.stable.lix) 524288000; # (if )
          #reexec = true;
          #NIX_SHOW_STATS=1
          #NIX_COUNT_CALLS=1
        };
      };

      nixpkgs.config.allowUnfree = true;

    }
    (mkIf cfg.lix {
      nix.package = pkgs.lixPackageSets.stable.lix;
      nixpkgs.overlays = [
        (_final: prev: {
          inherit (prev.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })
      ];
    })
    (mkIf cfg.nh {

      programs.nh.enable = true;
      programs.nh.flake = "/home/egor/my-little-flake";
      programs.nh.clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
        dates = "weekly";
      };
      environment.sessionVariables = {
        NH_NO_CHECKS = "true";
        # NH_LOG = "nh=trace";
      };
    })
    (mkIf cfg.ghtoken {
      # NIX_CONFIG="extra-access-tokens = github.com=github_pat_XYZ" nix ...
      # https://github.com/NixOS/nix/issues/6536
      nix.extraOptions = ''
        #!include ${config.sops.secrets."system/nix-token".path}
      '';
      sops.secrets."system/nix-token" = {
        mode = "0440";
        group = config.users.groups.keys.name;
        sopsFile = ../../secrets/common.yaml;
      };
    })
  ];
}
