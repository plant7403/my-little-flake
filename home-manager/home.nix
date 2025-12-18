# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}:

{
  # You can import other home-manager modules here
  imports = [

    # ./desktop/vscode.nix
    # ./desktop/firefox.nix
    # ./desktop/extensions.nix
    #./desktop/niri.nix
    ./desktop

    # ./core/zsh.nix
    # ./core/gpg.nix
    # ./core/theme.nix
    # ./core/radicle.nix
    ./core

    ./nvim/nvim.nix

    ./sops.nix

    inputs.impermanence.homeManagerModules.impermanence

  ]
  ++ (builtins.attrValues outputs.homeManagerModules);

  home = {
    username = "egor";
    homeDirectory = "/home/egor";
  };

  home.packages = with pkgs; [
    bitwarden-desktop
    blender

    inkscape
    krita
    libreoffice
    rnote

    nixpkgs-fmt
    nixfmt-rfc-style
    nil
    nixd

    simplex-chat-desktop
    sirikali

    transmission_4-gtk

    gnome-boxes

    deploy-rs
    gnome-decoder
    usbguard-notifier
    thunderbird

    nmap

    libresprite
    #pixelorama
    vlc

    prismlauncher
    jdk25_headless
    #alfis

    nym

    dbeaver-bin
    signal-desktop

    sptlrx # add ff extention
    bustle
    sushi

    grayjay

    boxbuddy
    crun
    distroshelf

    toml2nix
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

  programs.direnv = {
    #config = "true";
    enable = true;
    enableZshIntegration = true;
    mise.enable = true;
    nix-direnv.enable = true;
    silent = true;
    #stdlib = "true";
  };

  programs.thunderbird = {
    enable = true;
    profiles.default.isDefault = true;
  };

  programs.keepassxc = {
    enable = true;
    autostart = true;
    settings = {
      Browser.Enabled = true;

      GUI = {
        AdvancedSettings = true;
        ApplicationTheme = "classic";
        CompactMode = false;
        HidePasswords = true;
      };

      SSHAgent.Enabled = true;
    };
  };

  programs.distrobox = {
    containers = {
      common-debian = {
        additional_packages = "git";
        entry = true;
        image = "debian:13";
        init_hooks = [
          "ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/docker"
          "ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/docker-compose"
        ];
      };
    };
    enableSystemdUnit = true;
    enable = true;
    settings = {
      #container_additional_volumes = "/example:/example1 /example2:/example3:ro";
      container_always_pull = "1";
      container_generate_entry = 0;
      container_image_default = "registry.opensuse.org/opensuse/toolbox:latest";
      container_init_hook = "~/.local/distrobox/a_custom_default_init_hook.sh";
      container_manager = "docker";
      container_manager_additional_flags = "--env-file /path/to/file --custom-flag";
      container_name_default = "test-name-1";
      container_pre_init_hook = "~/a_custom_default_pre_init_hook.sh";
      container_user_custom_home = "$HOME/.local/share/container-home-test";
      non_interactive = "1";
      skip_workdir = "0";
    };
  };

  programs.freetube.enable = true;
  programs.freetube.settings = {
    allowDashAv1Formats = true;
    checkForUpdates = false;
    defaultQuality = "1080";
    #baseTheme           = "catppuccinMocha";
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

  /*
    programs.rbw.settings.email = "test@disroot.org";
    programs.rbw.settings.identity_url = "";
    programs.rbw.settings.base_url = "";
  */
  programs.rbw.enable = true;

  programs.element-desktop = {
    enable = true;
    profiles = {
      home = {
        disable_custom_urls = false;
        disable_guests = false;
        disable_login_language_selector = false;
        disable_3pid_login = false;
      };
    };
    settings = ''
      {
        default_server_config = {
          "m.homeserver" = {
              base_url = "https://matrix-client.matrix.org";
              server_name = "matrix.org";
          };
          "m.identity_server" = {
              base_url = "https://vector.im";
          };
        };
        disable_custom_urls = false;
        disable_guests = false;
        disable_login_language_selector = false;
        disable_3pid_login = false;
        force_verification = false;
        brand = "Element";
        integrations_ui_url = "https://scalar.vector.im/";
        integrations_rest_url = "https://scalar.vector.im/api";
      }
    '';
  };

  #home.sessionVariables = {
  #  MOZ_USE_XINPUT2 = "1";
  #};

  modules.yubikey-unlock = {
    enable = true;
    #host = "stellar";
  };

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
      ".config/Signal"

      "my-little-flake"
      "Pak-Unity"
      "Projects"

      "VirtualBox VMs"

      ".config/VSCodium/User"
      ".config/obsidian"
      ".config/keepassxc"
      #".config/zsh"
      #".config/gsconnect"
      # ".cache/nix-index"
      ".cache/thumbnails"

      #".local/state"
      #".steam"
      ".radicle"
      #".local/share/Steam"

      {
        directory = ".local/share/Steam/userdata";
        method = "symlink";
      }
      ".steam"

      ".config/paperwm"
      ".local/share/zsh"
    ];

    files = [
      ".config/gsconnect/certificate.pem"
      ".config/gsconnect/private.pem"
      ".config/syncthingtray.ini"
      ".cache/keepassxc/keepassxc.ini"
      ".mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"
      #".nix-defexpr/channels"
      #".nix-defexpr/channels_root"
      ".config/sops/age/keys.txt"
      ".screenrc"
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
