# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  config,
  inputs,
  sops-nix,
  outputs,
  ...
}:
let
in
{
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
    ./vscode.nix
    ./firefox.nix
    ./gpg.nix
    #./theme.nix
    inputs.stylix.homeManagerModules.stylix

  ]; # ++ (builtins.attrValues outputs.homeManagerModules);

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
    gnomeExtensions.tailscale-qs
    gnomeExtensions.tailscale-status
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
    transmission_4-gtk
    trayscale

    yubikey-touch-detector
    gnomeExtensions.appindicator
    mullvad-vpn
    #logseq
    light

    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    emote

    gnomeExtensions.grand-theft-focus
    gnomeExtensions.bing-wallpaper-changer
    gnomeExtensions.tiling-assistant
    gnomeExtensions.blur-my-shell

    palenight-theme
    dracula-theme
    #gnome-terminal

    yubico-piv-tool
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization
    yubikey-personalization-gui
    yubioath-flutter
    yubikey-touch-detector

    gnome-tweaks
    gnomeExtensions.appindicator
    gnupg

    gnome-boxes
    #virtualbox
    mullvad-browser
    yubico-pam
    freetube

    sops
    #davinci-resolve
    #flowblade
    kdenlive
    deploy-rs
    gnome-decoder
    usbguard-notifier

    nixfmt-rfc-style
    nil
    nixd
    age
    nmap

    libresprite
    pixelorama
    vlc
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "me@egor.wtf";
    userName = "me";

  };
  programs.gitui.enable = true;
  #services.syncthing = {
  #  enable = true;
  #  tray.enable = true;
  #};

  #home.sessionVariables = {
  #  MOZ_USE_XINPUT2 = "1";
  #};

  /*
      modules.yubikey-unlock = {
      enable = true;
      host = "stellar";
    };
  */
  #pam.yubico.authorizedYubiKeys
  #pam.yubico.authorizedYubiKeys.ids = [
  #  "19271673"
  #];

  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
