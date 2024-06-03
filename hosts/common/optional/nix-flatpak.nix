{...}: {
  services.flatpak.enable = true;
  #services.flatpak.remotes = [{ name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"; }];
  services.flatpak.update.onActivation = true;
  services.flatpak.update = {
    auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
    };
  };
}
