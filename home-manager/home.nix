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
    ./theme.nix
    ./extensions.nix
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

    filezilla
    #gimp-with-plugins
    inkscape
    jellyfin-media-player
    krita
    libreoffice

    #nextcloud-client
    nixpkgs-fmt
    rnote
    simplex-chat-desktop
    # sirikali
    thunderbird

    transmission_4-gtk

    #mullvad-vpn
    #logseq

    #gnome-terminal

    gnome-boxes
    #virtualbox
    #mullvad-browser

    freetube

    #davinci-resolve
    #flowblade

    deploy-rs
    gnome-decoder
    usbguard-notifier

    nixfmt-rfc-style
    nil
    nixd

    nmap

    libresprite
    #pixelorama
    vlc

    obsidian

    prismlauncher
    jdk23
    alfis

    basicswap
    nym

    keepassxc
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
