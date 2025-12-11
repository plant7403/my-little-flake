# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  #outputs,
  lib,
  outputs,
  inputs,
  ...
}:

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
    ./radicle.nix
    #./nvim.nix
    #./vim.nix
    #../modules/home-manager
    #outputs.homeManagerModules.syncthing
    inputs.impermanence.homeManagerModules.impermanence

  ]
  ++ (builtins.attrValues outputs.homeManagerModules);

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
    bitwarden-desktop
    blender
    #darktable
    direnv
    element-desktop

    filezilla
    #gimp-with-plugins
    inkscape
    #jellyfin-media-player
    krita
    libreoffice

    #nextcloud-client
    nixpkgs-fmt
    rnote
    simplex-chat-desktop
    sirikali
    thunderbird

    transmission_4-gtk

    easyeffects

    ghostty

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
    jdk25_headless
    #alfis

    #basicswap
    nym

    ungoogled-chromium
    dbeaver-bin
    signal-desktop

    sptlrx # add ff extention
    bustle
    sushi

  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.email = "me@o.o";
      user.name = "me";
    };
  };
  programs.gitui.enable = true;

  programs.bemenu = {
    enable = true;
    settings = {
      line-height = 28;
      prompt = "open";
      ignorecase = true;
      /*
        fb = "#1e1e2e";
           ff = "#cdd6f4";
           nb = "#1e1e2e";
           nf = "#cdd6f4";
           tb = "#1e1e2e";
           hb = "#1e1e2e";
           tf = "#f38ba8";
           hf = "#f9e2af";
           af = "#cdd6f4";
           ab = "#1e1e2e";
      */
      width-factor = 0.3;
    };
  };
  programs.keepassxc = {
    enable = true;
    autostart = true;
    settings = {
      Browser.Enabled = true;

      GUI = {
        AdvancedSettings = true;
        ApplicationTheme = "dark";
        CompactMode = true;
        HidePasswords = true;
      };

      SSHAgent.Enabled = true;
    };
  };

  programs.ssh.matchBlocks = {
    "*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = true;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
    foo = lib.hm.dag.entryBefore [ "github.com" ] {
      PreferredAuthentications = "publickey";
      IdentitiesOnly = "yes";
      User = "git";
      IdentityFile = "~/.ssh/git";
    };
    bar = lib.hm.dag.entryBefore [ "git.disroot.org" ] {
      PreferredAuthentications = "publickey";
      IdentitiesOnly = "yes";
      User = "git";
      IdentityFile = "~/.ssh/git-disroot";
    };
    /*
        pizza = lib.hm.dag.entryBefore [ "github.com" ] {

        };
    */

  };

  #home.sessionVariables = {
  #  MOZ_USE_XINPUT2 = "1";
  #};

  /*
    modules.yubikey-unlock = {
      enable = true;
      #host = "stellar";
    };
  */
  modules.syncthing.enable = true;
  #pam.yubico.authorizedYubiKeys
  #pam.yubico.authorizedYubiKeys.ids = [
  #  "19271673"
  #];

  # pam.yubico.authorizedYubiKeys.ids = [ "19271673" ];
  /*
    pam.yubico.authorizedYubiKeys.path
    services.yubikey-agent.enable
    services.yubikey-agent.package
  */

  home.persistence."/persist/home/egor" = {

    directories = [

      "Downloads"
      "Music"
      "Pictures"
      "Documents"

      "Sync"
      ".Secret"
      ".DecSync"
      "DCIM"

      ".gnupg"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".config/Element"
      ".config/.mozilla/thunderbird"
      ".thunderbird"
      ".librewolf/default"

      "my-little-flake"
      "Pak-Unity"
      "Projects"

      "VirtualBox VMs"

      ".config/VSCodium/User"
      ".config/obsidian"
      ".config/keepassxc"
      ".config/zsh"
      ".config/gsconnect"
      ".cache/nix-index"
      ".cache/thumbnails"

      ".local/state"
      ".steam"
      ".radicle"
      /*
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
      */
    ];

    files = [
      ".config/gsconnect/certificate.pem"
      ".config/gsconnect/private.pem"
      ".config/syncthingtray.ini"
      ".cache/keepassxc/keepassxc.ini"
      ".mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"
      ".nix-defexpr/channels"
      ".nix-defexpr/channels_root"
      #".nix-profile"
    ];

    allowOther = true;
  };

  xdg.userDirs.createDirectories = true;
  xdg.userDirs.enable = true;

  nix.gc = {
    automatic = true;
    dates = "16:20";
    persistent = true;
  };
  /*
    xdg.userDirs.extraConfig = {
      LC_ALL = "es_ES.UTF-8";
    };
  */

  #systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
