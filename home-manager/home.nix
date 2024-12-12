# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  config,
  inputs,
  sops-nix,
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
    #./sops.nix
    inputs.stylix.homeManagerModules.stylix
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

    #theme = {
    #  name = "Dracula";
    #  package = pkgs.dracula-theme;
    # };

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
  #  platformTheme.name = "Dracula";
  #  style.name = "Dracula";
  #};

  #home.sessionVariables.GTK_THEME = "Dracula";
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
        #"tailscale-status@maxgallup.github.com"
        "tailscale@joaophi.github.com"
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
        "virtualbox.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      workspace-names = ["Main"];
    };
    #"org/gnome/desktop/background" = {
    #  picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-l.png";
    #  picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
    #};
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
      primary-color = "#3465a4";
      secondary-color = "#000000";
    };
    #"org/gnome/shell/extensions/user-theme" = {
    #  name = "Dracula";
    #};
  };

  stylix.enable = true;
  stylix.polarity = "dark";
  #stylix.image = /run/current-system/sw/share/backgrounds/gnome/vnc-d.png;
  stylix.image = pkgs.fetchurl {
    url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-dracula.png?raw=true";
    sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
  };
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-city-dark.yaml";
  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };

    monospace = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
  programs.nushell.enable = true;
  programs.kitty.enable = true;
  programs.alacritty.enable = true;

  programs.gpg = {
    scdaemonSettings.disable-ccid = true;
    settings = {
      # https://github.com/drduh/config/blob/master/gpg.conf
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Options.html
      # 'gpg --version' to get capabilities
      # Use AES256, 192, or 128 as cipher
      personal-cipher-preferences = "AES256 AES192 AES";
      # Use SHA512, 384, or 256 as digest
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      # Use ZLIB, BZIP2, ZIP, or no compression
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      # Default preferences for new keys
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      # SHA512 as digest to sign keys
      cert-digest-algo = "SHA512";
      # SHA512 as digest for symmetric ops
      s2k-digest-algo = "SHA512";
      # AES256 as cipher for symmetric ops
      s2k-cipher-algo = "AES256";
      # UTF-8 support for compatibility
      charset = "utf-8";
      # No comments in messages
      no-comments = true;
      # No version in output
      no-emit-version = true;
      # Disable banner
      no-greeting = true;
      # Long key id format
      keyid-format = "0xlong";
      # Display UID validity
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      # Display all keys and their fingerprints
      with-fingerprint = true;
      # Display key origins and updates
      #with-key-origin
      # Cross-certify subkeys are present and valid
      require-cross-certification = true;
      # Disable caching of passphrase for symmetrical ops
      no-symkey-cache = true;
      # Output ASCII instead of binary
      armor = true;
      # Enable smartcard
      use-agent = true;
      # Disable recipient key ID in messages (breaks Mailvelope)
      throw-keyids = true;
      # Default key ID to use (helpful with throw-keyids)
      #default-key 0xFF3E7D88647EBCDB
      #trusted-key 0xFF3E7D88647EBCDB
      # Group recipient keys (preferred ID last)
      #group keygroup = 0xFF00000000000001 0xFF00000000000002 0xFF3E7D88647EBCDB
      # Keyserver URL
      #keyserver hkps://keys.openpgp.org
      #keyserver hkps://keys.mailvelope.com
      #keyserver hkps://keyserver.ubuntu.com:443
      #keyserver hkps://pgpkeys.eu
      #keyserver hkps://pgp.circl.lu
      #keyserver hkp://zkaan2xfbuxia2wpf7ofnkbz6r5zdbbvxbunvp5g2iebopbfc4iqmbad.onion
      # Keyserver proxy
      #keyserver-options http-proxy=http://127.0.0.1:8118
      #keyserver-options http-proxy=socks5-hostname://127.0.0.1:9050
      # Enable key retrieval using WKD and DANE
      #auto-key-locate wkd,dane,local
      #auto-key-retrieve
      # Trust delegation mechanism
      #trust-model tofu+pgp
      # Show expired subkeys
      #list-options show-unusable-subkeys
      # Verbose output
      #verbose
    };
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    enableZshIntegration = true;
    enableScDaemon = true;
    #pinentryPackage = pkgs.pinentry-gnome3;
    extraConfig = ''
      ttyname $GPG_TTY
    '';
    pinentryPackage = pkgs.pinentry-curses;
  };

  #imports = [
  #  inputs.sops-nix.homeManagerModules.sops
  #];
  sops = {
    gnupg = {
      home = "~/.gnupg";
      sshKeyPaths = [];
    };
    #defaultSymlinkPath = "/run/user/1000/secrets";
    #defaultSecretsMountPoint = "/run/user/1000/secrets.d";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    #age.keyFile = /home/egor/.config/sops/age/keys.txt;
  };

  #pam.yubico.authorizedYubiKeys
  # FIXME - !!!SOPS!!!
  home.file.".config/Yubico/u2f_keys".source = config.lib.file.mkOutOfStoreSymlink config.sops.secrets."users/egor/yubikey".path;

  sops.secrets."users/egor/yubikey" = {
    sopsFile = ./secrets.yaml;
  };
  #pam.yubico.authorizedYubiKeys.ids = [
  #  "19271673"
  #];

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
  home.stateVersion = "24.05";

  home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
    /run/current-system/sw/bin/systemctl start --user sops-nix
  '';
  systemd.user.services.mbsync.Unit.After = ["sops-nix.service"];
}
