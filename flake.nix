{
  description = "Your new nix config";

  inputs = {
    #FIXME - Check inputs

    # Nixpkgs
    #    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    /*
      nur.url = "github:nix-community/NUR/master";
      nur.inputs.nixpkgs.follows = "nixpkgs";
    */

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    #flatpaks.url = "github:GermanBread/declarative-flatpak/stable";

    #conduit = {
    #  url = "gitlab:famedly/conduit";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #hardware.url = "github:nixos/nixos-hardware";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    /*
        openhab.url = "github:nagisa/nixpkg-openhab";
        openhab.inputs = {
      # In case you already depend on `nixpkgs` in your flake, consider having `openhab`
      # “follow” it:
      nixpkgs.follows = "nixpkgs";
      # Similarly, for flake-utils:
      #flake-utils.follows = "flake-utils";
      };
    */

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    /*
        nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      #url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.04";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs-22_11.follows = "nixpkgs";
      #inputs.nixpkgs-23_05.follows = "nixpkgs";
      #inputs.nixpkgs-23_11.follows = "nixpkgs";
        };
    */
    #firefox-addons = {
    #  url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    /*
      wp4nix = {
      url = "git+https://git.helsinki.tools/helsinki-systems/wp4nix.git?ref=master";
      flake = false;
      #ref = "master";
        };
    */
    musnix = {
      url = "github:musnix/musnix";
    };
    # vscode-server.url = "github:nix-community/nixos-vscode-server";
    deploy-rs.url = "github:serokell/deploy-rs";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    /*
      auto-cpufreq = {
         url = "github:AdnanHodzic/auto-cpufreq";
         inputs.nixpkgs.follows = "nixpkgs";
       };
    */
  };
  /*
    , hardware
       , lanzaboote
       , disko
       , nixos-mailserver
       , musnix
       , nix-flatpak
       , stylix
       , jovian
       , firefox-addons
     , #flatpaks,
  */
  /*
    , vscode-server
       , deploy-rs
       , sops-nix
  */

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      deploy-rs,
      sops-nix,
      disko,
      lanzaboote,
      jovian,
      stylix,
      # plasma-manager,
      #nix-vscode-extensions,
      nix4vscode,
      ...
    }:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      system = builtins.currentSystem;
      # Unmodified nixpkgs
      pkgs = import nixpkgs { inherit system; };
      # nixpkgs with deploy-rs overlay but force the nixpkgs package
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      rootPath = ./.;

      deployPkgs = import nixpkgs {
        inherit system;
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
      # Acessible through 'nix build', 'nix shell', etc
      #    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.${system}.nixfmt-rfc-style);

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

            #vscode-server.nixosModules.default
            #({...}: {
            #  services.vscode-server.enable = true;
            #  services.vscode-server.installPath = "~/.vscodium-server";
            #})
          ];
        };
        luna = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/luna/configuration.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.egor = import ./home-manager/home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.backupFileExtension = "backup";
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
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.egor = import ./home-manager/saturn.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.backupFileExtension = "backup";
            }
            {
              nixpkgs.overlays = [
                nix4vscode.overlays.default
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
        saturn = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = with self.nixosModules; [
            ./hosts/saturn/configuration.nix
            sops-nix.nixosModules.sops
            disko.nixosModules.disko
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.egor = import ./home-manager/saturn.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.backupFileExtension = "backup";
              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
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
        stellar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/stellar/configuration.nix
            sops-nix.nixosModules.sops
            disko.nixosModules.disko
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.egor = import ./home-manager/saturn.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.backupFileExtension = "backup";

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
              nixpkgs.overlays = [
                nix4vscode.overlays.default
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
                /*
                  services.dovecot2.sieve.extensions = [ "fileinto" ];
                  mailserver = {
                    enable = true;
                    fqdn = "mail.egor.wtf";
                    domains = [ "egor.wtf" ];
                    # A list of all login accounts. To create the password hashes, use
                    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
                    loginAccounts = {
                      "me@egor.wtf" = {
                        hashedPasswordFile = config.sops.secrets."mail/egor.wtf/me".path;
                        aliases = [ "postmaster@egor.wtf" ];
                      };
                      "hello@egor.wtf" = {
                        hashedPasswordFile = config.sops.secrets."mail/egor.wtf/me".path;
                      };
                    };
                    certificateScheme = "acme-nginx";
                  };
                */
                security.acme.acceptTerms = true;
                security.acme.defaults.email = "ssl@egor.wtf";

                sops.secrets."mail/egor.wtf/me" = {
                  #owner = "nextcloud";
                };
              }
            )
          ];
        };
        comet = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/comet/configuration.nix
            sops-nix.nixosModules.sops
          ];
        };
      };
      deploy.nodes = {
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
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      #    homeConfigurations = {
      #      "egor@luna" = home-manager.lib.homeManagerConfiguration {
      #        inherit pkgs;
      #        extraSpecialArgs = {inherit inputs outputs;};
      #        modules = [
      #
      #        ];
      #      };
      #    };
      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      #    homeConfigurations = {
      #      "egor@immortal" = home-manager.lib.homeManagerConfiguration {
      #        pkgs = nixpkgs.x86_64-linux; # Home-manager requires 'pkgs' instance
      #        extraSpecialArgs = {inherit inputs outputs;};
      #        modules = [
      # > Our main home-manager configuration file <
      #          ./home-manager/home.nix
      #        ];
      #      };
      #      "egor@saturn" = home-manager.lib.homeManagerConfiguration {
      #        pkgs = nixpkgs.x86_64-linux; # Home-manager requires 'pkgs' instance
      #        extraSpecialArgs = {inherit inputs outputs;};
      #        modules = [
      #          # > Our main home-manager configuration file <
      #          ./home-manager/home.nix
      #        ];
      #      };
      #      "egor@luna" = home-manager.lib.homeManagerConfiguration {
      #        pkgs = nixpkgs.x86_64-linux; # Home-manager requires 'pkgs' instance
      #        extraSpecialArgs = {inherit inputs outputs;};
      #        modules = [
      #          # > Our main home-manager configuration file <
      #          ./home-manager/home.nix
      #        ];
      #      };
      #    };
    };
}
