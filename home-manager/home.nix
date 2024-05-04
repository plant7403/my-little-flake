# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{pkgs, ...}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./zsh.nix
    ./sops.nix
  ];

  # TODO: Set your username
  home = {
    username = "egor";
    homeDirectory = "/home/egor";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    #  thunderbird
    #librewolf
    alejandra
    arduino
    bitwarden
    blender
    darktable
    direnv
    element-desktop
    evolution
    filezilla
    fractal
    #gimp-with-plugins
    gnomeExtensions.caffeine
    gnomeExtensions.gjs-osk
    gnomeExtensions.tailscale-qs
    gnomeExtensions.tailscale-status
    gnomeExtensions.touch-x
    #gnomeExtensions.syncthing-indicator
    inkscape
    jellyfin-media-player
    krita
    libfido2
    libnotify
    libreoffice
    mailspring
    mosh
    nextcloud-client
    nixpkgs-fmt
    rnote
    simplex-chat-desktop
    sirikali
    sops
    thefuck
    thunderbird
    tmux
    transmission-qt
    trayscale
    vscodium
    yubikey-touch-detector
    gnomeExtensions.appindicator
    mullvad-vpn
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "me@egor.wtf";
    userName = "me";
  };
  programs.gitui.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # Themes
      dracula-theme.theme-dracula
      #ahmadawais.shades-of-purple
      # Visuals
      pkief.material-icon-theme
      # NixOS
      jnoortheen.nix-ide

      #pinage404.nix-extension-pack

      #arrterian.nix-env-selector
    ];
  };

  #home.sessionVariables = {
  #  MOZ_USE_XINPUT2 = "1";
  #};

  #programs.bash.bashrcExtra = ''
  #  TEST="$(cat ${config.sops.secrets."example".path})"
  #'';

  programs.librewolf = {
    enable = true;
    #    package = pkgs.librewolf;
    #profiles.default.extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
    #  ublock-origin
    #  bitwarden
    #];
  };
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
