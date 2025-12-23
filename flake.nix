{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    /*
        nix-index-database.url = "github:nix-community/nix-index-database";
        nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    */
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    direnv-instant.url = "github:Mic92/direnv-instant";

    stylix.url = "github:danth/stylix";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";
    # kickstart-nixvim.url = "github:JMartJonesy/kickstart.nixvim"; # !! IM NOT USING IT
    #nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    #flatpaks.url = "github:GermanBread/declarative-flatpak/stable";

    #nixos-facter-modules.url = "github:numtide/nixos-facter-modules"; # !! RPI WEIRD FLAKE

    impermanence.url = "github:nix-community/impermanence";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      deploy-rs,
      sops-nix,
      disko,
      lanzaboote,
      jovian,
      stylix,
      nix4vscode,
      nix-ld,

      ...
    }@inputs:
    let
      inherit (self) outputs;
      #inherit (nixpkgs) lib;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
      #system = builtins.currentSystem;
      # Unmodified nixpkgs
      # pkgs = import nixpkgs { inherit system; };
      pkgs = import <nixpkgs> {
        config.allowUnfree = true;
        system = "x86_64-linux"; # One of supported systems
        overlays = [
          nix4vscode.overlays.default
          #self.overlays.no-dochecks
        ];
      };
      # nixpkgs with deploy-rs overlay but force the nixpkgs package

      rootPath = ./.;

      deployPkgs = import nixpkgs {
        inherit systems;
        overlays = [
          deploy-rs.overlay
          (_self: super: {
            deploy-rs = {
              inherit (pkgs) deploy-rs;
              lib = super.deploy-rs.lib;
            };
          })
        ];
      };
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      /*
        packages = forAllSystems (
            system:
            let
              nixvim' = nixvim.legacyPackages.${system};
              nvim = nixvim'.makeNixvim.config;
            in
            {
              inherit nvim;
              default = nvim;
            }
          );
      */

      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays {
        inherit inputs;
      };

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        /*
          immortal = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/immortal/configuration.nix
              sops-nix.nixosModules.sops
              disko.nixosModules.disko
              lanzaboote.nixosModules.lanzaboote
              (
                {
                  pkgs,
                  lib,
                  ...
                }:
                {
                  environment.systemPackages = [
                    pkgs.sbctl
                  ];

                  boot.loader.systemd-boot.enable = lib.mkForce false;

                  boot.lanzaboote = {
                    enable = true;
                    pkiBundle = "/var/lib/sbctl";
                  };
                }
              )
            ];
          };
        */
        /*
          luna = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/luna/configuration.nix
              sops-nix.nixosModules.sops
              home-manager.nixosModules.home-manager
              (
                { lib, ... }:
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.egor = import ./home-manager/home.nix;
                  home-manager.extraSpecialArgs = { inherit inputs; };
                  home-manager.backupFileExtension = "backup";
                  #home-manager.backupCommand = lib.literalExpression "''${pkgs.trash-cli}/bin/trash";
                }
              )
              lanzaboote.nixosModules.lanzaboote
              (
                {
                  pkgs,
                  lib,
                  ...
                }:
                {
                  environment.systemPackages = [
                    pkgs.sbctl
                  ];

                  boot.loader.systemd-boot.enable = lib.mkForce false;

                  boot.lanzaboote = {
                    enable = true;
                    pkiBundle = "/var/lib/sbctl";
                  };
                }
              )
            ];
          };
        */
        horizon = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/horizon/configuration.nix
            sops-nix.nixosModules.sops
            jovian.nixosModules.jovian
            disko.nixosModules.disko
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            (
              { lib, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                environment.pathsToLink = [
                  "/share/applications"
                  "/share/xdg-desktop-portal"
                ];
                home-manager.users.egor = import ./home-manager/saturn.nix;
                home-manager.extraSpecialArgs = { inherit inputs outputs; };
                home-manager.backupFileExtension = "backup";
                #home-manager.backupCommand = lib.literalExpression "''${pkgs.trash-cli}/bin/trash";
              }
            )

            {
              nixpkgs.overlays = [
                nix4vscode.overlays.default
                self.overlays.modifications
              ];
            }

            lanzaboote.nixosModules.lanzaboote
            (
              {
                pkgs,
                lib,
                ...
              }:
              {
                environment.systemPackages = [
                  pkgs.sbctl
                ];

                boot.loader.systemd-boot.enable = lib.mkForce false;

                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/var/lib/sbctl";
                };
              }
            )
          ];
        };
        /*
          saturn = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = with self.nixosModules; [
              ./hosts/saturn/configuration.nix
              sops-nix.nixosModules.sops
              disko.nixosModules.disko
              stylix.nixosModules.stylix
              home-manager.nixosModules.home-manager
              (
                { lib, ... }:
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.egor = import ./home-manager/saturn.nix;
                  home-manager.extraSpecialArgs = { inherit inputs; };
                  home-manager.backupFileExtension = "backup";
                  #home-manager.backupCommand = lib.literalExpression "''${pkgs.trash-cli}/bin/trash";
                  # Optionally, use home-manager.extraSpecialArgs to pass
                  # arguments to home.nix
                }
              )
              inputs.musnix.nixosModules.musnix
              {
                musnix.enable = true;
                musnix.alsaSeq.enable = true;
                musnix.ffado.enable = true;
                musnix.rtcqs.enable = true;
                #musnix.kernel.realtime = true;
              }
            ];
          };
        */
        stellar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/stellar/configuration.nix
            # ... add this line to the rest of your configuration modules
            nix-ld.nixosModules.nix-ld
            #nix-index-database.homeModules.default
            # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
            # to not collide with the nixpkgs version.
            { programs.nix-ld.dev.enable = true; }
            sops-nix.nixosModules.sops
            disko.nixosModules.disko
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            (
              { lib, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                environment.pathsToLink = [
                  "/share/applications"
                  "/share/xdg-desktop-portal"
                ];
                home-manager.users.egor = import ./home-manager/saturn.nix;
                home-manager.extraSpecialArgs = { inherit inputs outputs; };
                home-manager.backupFileExtension = "backup";
                #home-manager.backupCommand = lib.literalExpression "''${pkgs.trash-cli}/bin/trash";

                # Optionally, use home-manager.extraSpecialArgs to pass
                # arguments to home.nix
                nixpkgs.overlays = [
                  nix4vscode.overlays.default
                ];
              }
            )

            lanzaboote.nixosModules.lanzaboote
            (
              {
                pkgs,
                lib,
                ...
              }:
              {
                environment.systemPackages = [
                  pkgs.sbctl
                ];

                boot.loader.systemd-boot.enable = lib.mkForce false;

                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/var/lib/sbctl";
                };
              }
            )
            inputs.musnix.nixosModules.musnix
            {
              musnix.enable = true;
              musnix.alsaSeq.enable = true;
              musnix.ffado.enable = true;
              musnix.rtcqs.enable = true;
              musnix.kernel.realtime = false;
            }
          ];
        };
        /*
          pluto = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/pluto/configuration.nix
              disko.nixosModules.disko
              #{disko.devices.disk.disk1.device = "/dev/vda";}
              sops-nix.nixosModules.sops
              # nixos-mailserver.nixosModule
              (
                { config, ... }:
                {

                  security.acme.acceptTerms = true;
                  security.acme.defaults.email = "ssl@egor.wtf";

                  sops.secrets."mail/egor.wtf/me" = {
                    #owner = "nextcloud";
                  };
                }
              )
            ];
          };
        */
        /*
          comet = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/comet/configuration.nix
              sops-nix.nixosModules.sops
            ];
          };
        */
        hole = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = with self.nixosModules; [
            ./hosts/hole/configuration.nix
            #sops-nix.nixosModules.sops
            nixos-facter-modules.nixosModules.facter
            { config.facter.reportPath = ./hosts/hole/facter.json; }
            disko.nixosModules.disko
            /*
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.egor = import ./home-manager/saturn.nix;
                home-manager.extraSpecialArgs = { inherit inputs; };
                home-manager.backupFileExtension = "backup";
                #home-manager.backupCommand = lib.literalExpression "''${pkgs.trash-cli}/bin/trash";
                # Optionally, use home-manager.extraSpecialArgs to pass
                # arguments to home.nix
              }
            */
          ];
        };

      };
      deploy.nodes = {
        /*
          immortal = {
            sshOpts = [
              "-p"
              "3370"
            ];
            hostname = "100.64.0.1";
            fastConnection = true;
            profiles = {
              system = {
                sshUser = "root";
                path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.immortal;
                user = "root";
                remoteBuild = true;
              };
            };
          };
        */
        /*
          saturn = {
            sshOpts = [
              "-p"
              "3370"
            ];
            hostname = "100.64.0.4";
            fastConnection = true;
            profiles = {
              system = {
                sshUser = "root";
                path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.saturn;
                user = "root";
                remoteBuild = true;
              };
            };
          };
        */
        /*
          luna = {
            sshOpts = [
              "-p"
              "3370"
            ];
            hostname = "100.64.0.2";
            fastConnection = true;
            profiles = {
              system = {
                sshUser = "root";
                path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.luna;
                user = "root";
              };
            };
          };
        */
        /*
          pluto = {
            sshOpts = [
              "-p"
              "3370"
            ];
            hostname = "100.64.0.5";
            fastConnection = true;
            profiles = {
              system = {
                sshUser = "root";
                path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.pluto;
                user = "root";
              };
            };
          };
        */
        horizon = {
          sshOpts = [
            "-p"
            "3370"
          ];
          hostname = "100.64.0.6";
          fastConnection = true;
          profiles = {
            system = {
              sshUser = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.horizon;
              user = "root";
              remoteBuild = true;
            };
          };
        };
        stellar = {
          sshOpts = [
            "-p"
            "3370"
          ];
          hostname = "100.64.0.7";
          fastConnection = true;
          profiles = {
            system = {
              sshUser = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.stellar;
              user = "root";
              remoteBuild = true;
            };
          };
        };
        hole = {
          sshOpts = [
            "-p"
            "3370"
          ];
          hostname = "192.168.0.123";
          fastConnection = true;
          profiles = {
            system = {
              sshUser = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.stellar;
              user = "root";
              remoteBuild = true;
            };
          };
        };
      };
      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShells.default = pkgs.mkShell {

        packages = with pkgs; [
          node2nix
          nodejs
          pnpm
          yarn
        ];
        shellHook = ''

          echo "node `${pkgs.nodejs}/bin/node --version`"

        '';
      };
    };

}
