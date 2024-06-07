# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  config,
  ...
}: {
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
    logseq
    light

    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals

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

    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    gnupg

    gnome.gnome-boxes
    #virtualbox
    mullvad-browser
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

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  #systemd.user.sessionVariables = config.home-manager.users.egor.home.sessionVariables;

  #qt = {
  #  enable = true;
  #  platformTheme.name = "dracula";
  #  style.name = "dracula";
  #};

  home.sessionVariables.GTK_THEME = "Dracula";
  # ...

  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"
        "Vitals@CoreCoding.com"
        "caffeine@patapon.info"
        "tailscale-status@maxgallup.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];

      favorite-apps = [
        "org.gnome.Console.desktop"
        "librewolf.desktop"
        "codium.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Fractal.desktop"
        "bitwarden.desktop"
        "logseq.desktop"
        "com.github.iwalton3.jellyfin-media-player.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      workspace-names = ["Main"];
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-l.png";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
      primary-color = "#3465a4";
      secondary-color = "#000000";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Dracula";
    };
  };

  #home.file.".gnupg/gpg-agent.conf" = {
  #  onChange = true;
  #  text = ''
  #    # https://github.com/drduh/config/blob/master/gpg-agent.conf
  #    # https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html
  #    pinentry-program /usr/bin/pinentry-gnome3
  #pinentry-program /usr/bin/pinentry-tty
  #pinentry-program /usr/bin/pinentry-x11
  #pinentry-program /usr/local/bin/pinentry-curses
  #pinentry-program /usr/local/bin/pinentry-mac
  #pinentry-program /opt/homebrew/bin/pinentry-mac
  #pinentry-program /usr/bin/pinentry-curses
  #    enable-ssh-support
  #    ttyname $GPG_TTY
  #    default-cache-ttl 60
  #    max-cache-ttl 120
  #  '';
  #};
  programs.gpg.scdaemonSettings.disable-ccid = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    enableZshIntegration = true;
    enableScDaemon = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    extraConfig = ''
      ttyname $GPG_TTY
    '';
  };

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
