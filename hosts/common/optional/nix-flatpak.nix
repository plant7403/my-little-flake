{ inputs, ... }:
{
<<<<<<< HEAD
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak.enable = true;
  #services.flatpak.remotes = [{ name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"; }];
  #services.flatpak.update.onActivation = true;
  /*
=======
  /*
    imports = [
      inputs.nix-flatpak.nixosModules.nix-flatpak
    ];

    services.flatpak.enable = true;
    #services.flatpak.remotes = [{ name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"; }];
    services.flatpak.update.onActivation = true;
>>>>>>> 0cb1a125 (changes from stellar on mié 31 dic 2025 11:37:03 CET)
    services.flatpak.update = {
      auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };
    };
<<<<<<< HEAD
  */
  environment.persistence."/persist".directories = [
    "/var/lib/flatpak/"
  ];
  xdg.portal.enable = true;
=======
    environment.persistence."/persist".directories = [
      "/var/lib/flatpak/"
    ];
  */
>>>>>>> 0cb1a125 (changes from stellar on mié 31 dic 2025 11:37:03 CET)
}
