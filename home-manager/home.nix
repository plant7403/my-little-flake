# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  lib,
  outputs,
  inputs,
  config,
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
    inputs.direnv-instant.homeModules.direnv-instant

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
    textsnatcher
    normcap

    doctl

    bat
    lsd
    delta
    duf
    fd
    ripgrep
    jq
    tldr
    gtop
    gping
    procs
    htop
    smartmontools
    perf
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.email = "me@o.o";
      user.name = "me";
    };
    lfs = {
      enable = true;
    };
    iniContent.gpg.format = lib.mkForce "ssh";
    extraConfig = {
      checkout.defaultRemote = "origin";
      core.eol = "lf";
      gpg.format = lib.mkForce "ssh";
      commit.gpgsign = true;
      user.signingkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4OqADgjR4tD/2BFBTfhoi8AchffLyayrr0X5FSKC00ONzNpYeynuw9+bVbZ5a+O1EI3PPyCXKlmC4U3ZGl/jJWauhyXvT0068LC+hVwJfBwrHNbaq9b1Urgz2Mcv2tX9jbpi0hnxHwCQDTNtXptgxDvSLdz86gc6cBg48Y0cntSeNbHbvWFrcZ0iXUJYMpSVHNKPyR25r7SeNtXFvXzPTjPq/+wGsfnhXqbNDwec41zMsc4TBxHVKELFa1AaQF4QQ2SPQsWLSJ151EkybM4OfBxLulgqCzBYkHfjlqWuQqCwN9DOgFimoFLWJT9f8PUOHsu8q0ryTx7viyiFXK51enMGvthP4uRLWn6WdDb7zhe48HGbkWkVXETx78u5bL7hyIlMu9L3AB8gWKI7BYD+FrUyZkasK/e+JO0ECoil4c6jasqInvLVcyQY0loVyppL89CGTZZfTreZLv4Tt6rFuF9sBQ/FqDuA2L2wRgPZKRj1HiO3pppiAKuu5EG2Faotoi49WqM+RJD6O1RG7jWjCYKHB8TfiqrObJt9YRjYBctbWlNzZQs6oC1hKsLkfx1fjSA8PLDevPvK5jPgU6cUEFK22GouVxbdp8ZicTsi7AK6xGxJ2uENPAMFIuh6tqU6u9nI7mceK0vv343Y3pvvc0MawH/nS4+kIG57lL8hnNQ== cardno:19_271_673";
      diff.colorMoved = "zebra";
      fetch.prune = true;
      init.defaultBranch = "main";
      rebase.autostash = true;
      rebase.autoSquash = true;
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.tool = "vscode";
      merge.conflictStyle = "diff3";
      diff.tool = "vscode";
      mergeTool = {
        keepBackup = false;
        vscode.cmd = "code --wait --new-window $MERGED";
      };
      difftool.vscode.cmd = "code --wait --new-window --diff $LOCAL $REMOTE";
      include.path = "./local";
    };
  };
  programs.jujutsu = {
    enable = true;
    settings = {
      # Config reference
      # https://andre.arko.net/2025/10/15/jj-part-4-configuration/
      # consider user.name/email unset to encourage setting them per-repo?
      user.name = config.programs.git.userName;
      user.email = config.programs.git.userEmail;
      git.colocate = true;

      signing = {
        behavior = "own";
        backend = "ssh";
        key = config.programs.git.extraConfig.user.signingkey;
      };

      colors = {
        commit_id = "magenta";
        change_id = "cyan";
        "working_copy empty" = "green";
        "working_copy placeholder" = "red";
        "working_copy description placeholder" = "yellow";
        "working_copy empty description placeholder" = "green";
        prefix = {
          bold = true;
          fg = "cyan";
        };
        rest = {
          bold = false;
          fg = "bright black";
        };
        "node elided" = "yellow";
        "node working_copy" = "green";
        "node conflict" = "red";
        "node immutable" = "red";
        "node normal" = {
          bold = false;
        };
        "node" = {
          bold = false;
        };
      };
      git = {
        sign-on-push = true;
        write-change-id-header = true;
      };
      aliases = {
        d = [ "diff" ];
        l = [ "log" ];
        ll = [
          "log"
          "-r"
          ".."
        ];
        tug = [
          "bookmark"
          "move"
          "--from"
          "heads(::@- & bookmarks())"
          "--to"
          "@-"
        ];
      };
      revsets = {
        log = "current_work";
      };
      revset-aliases = {
        "stack()" = "ancestors(reachable(@, mutable()), 2)";
        "stack(x)" = "ancestors(reachable(x, mutable()), 2)";
        "stack(x, n)" = "ancestors(reachable(x, mutable()), n)";
        "current_work" = "trunk()..@ | @..trunk() | trunk() | @:: | fork_point(trunk() | @)";
      };
      template-aliases = {
        "abbreviate_timestamp_suffix(s, suffix, abbr)" = ''
          if(
              s.ends_with(suffix),
              s.remove_suffix(suffix) ++ label("timestamp", abbr)
          )
        '';
        "abbreviate_relative_timestamp(s)" = ''
          coalesce(
              abbreviate_timestamp_suffix(s, " millisecond", "ms"),
              abbreviate_timestamp_suffix(s, " second", "s"),
              abbreviate_timestamp_suffix(s, " minute", "m"),
              abbreviate_timestamp_suffix(s, " hour", "h"),
              abbreviate_timestamp_suffix(s, " day", "d"),
              abbreviate_timestamp_suffix(s, " week", "w"),
              abbreviate_timestamp_suffix(s, " month", "mo"),
              abbreviate_timestamp_suffix(s, " year", "y"),
              s
          )
        '';
        "format_timestamp(timestamp)" = ''
          coalesce(
              if(timestamp.after("1 minute ago"), label("timestamp", "<=1m")),
              abbreviate_relative_timestamp(timestamp.ago().remove_suffix(' ago').remove_suffix('s'))
          )
        '';
      };
      templates = {
        draft_commit_description = ''
          concat(
            coalesce(description, default_commit_description, "\n"),
            if(
              config("ui.should-sign-off").as_boolean() && !description.contains("Signed-off-by: " ++ author.name()),
              "\nSigned-off-by: " ++ author.name() ++ " <" ++ author.email() ++ ">",
            ),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';
      };
    };
  };

  /*
    programs.ssh = {
      agentPKCS11Whitelist = "${pkgs.tpm2-pkcs11-esapi}/lib/*";
    };
  */
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

  programs.direnv-instant.enable = true;

  programs.keepassxc = {
    enable = true;
    autostart = true;
    settings = {
      #FdoSecrets.Enabled = true;
      Browser = {
        Enabled = true;
        CustomProxyLocation = null;

        ShowNotification = true;
        UnlockDatabase = true;
        #UpdateBinaryPath = false;
        UseCustomBrowser = true;
        CustomBrowserType = "firefox";
        CustomBrowserLocation = "librewolf";
        AllowLocalhostWithPasskeys = true;

        #CustomExtensionId = "Ds+Kxi99E8PV7sjkisTgnfTkxy8wxQrI3mGLKazeqms=";
      };
      General.ConfigVersion = 2;

      GUI = {
        AdvancedSettings = true;
        ApplicationTheme = "classic";
        CompactMode = false;
        HidePasswords = true;
        ColorPasswords = true;
        ShowTrayIcon = true;
        MinimizeToTray = true;
        MinimizeOnStartup = true;
        MinimizeOnClose = true;
      };

      KeeShare = {

      };
      Security.QuickUnlock = true;

      SSHAgent.Enabled = true;
    };
  };
  programs.rbw = {
    enable = true;
    settings = {
      email = "sensitive_ranging@getgoogleoff.me";
      identity_url = "https://passwords.pak.academy/identity";
      base_url = "https://passwords.pak.academy/";
      ui_url = "https://passwords.pak.academy/";
      notifications_url = "https://passwords.pak.academy/notifications";
      pinentry = pkgs.pinentry-curses;
    };
  };

  programs.distrobox = {
    containers = {
      common-debian = {
        additional_packages = "git";
        entry = true;
        image = "debian:13";
        init_hooks = [
          "ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman"
          "ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/pdoman-compose"
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
      container_manager = "podman";
      #container_manager_additional_flags = "--env-file /path/to/file --custom-flag";
      #container_name_default = "test-name-1";
      #container_pre_init_hook = "~/a_custom_default_pre_init_hook.sh";
      #container_user_custom_home = "$HOME/.local/share/container-home-test";
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
      setEnv.TERM = "xterm-256color";
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
    # @blocksort
    directories = [

      ".cache/thumbnails"
      ".config/.mozilla/thunderbird"
      ".config/Element"
      ".config/keepassxc"

      ".config/obsidian"
      ".config/paperwm"
      ".config/rbw"
      ".config/Signal"

      ".config/VSCodium/User"
      ".DecSync"
      ".gnupg"
      ".librewolf/default"
      ".local/share/direnv"
      ".local/share/keyrings"
      ".local/share/rbw"
      ".local/share/zsh"
      ".local/state/syncthing"
      ".radicle"

      ".Secret"
      ".ssh"
      ".steam"

      ".thunderbird"

      "DCIM"
      "Documents"
      "Downloads"
      "Music"
      "my-little-flake"
      "Pak-Unity"
      "Pictures"

      "Projects"
      "Sync"
      "VirtualBox VMs"
      #".local/share/Steam"

      {
        directory = ".local/share/Steam/userdata";
        method = "symlink";
      }
      # ".cache/nix-index"

      #".config/gsconnect"
      #".config/zsh"

      #".local/state"
      #".steam"

    ];
    # @blocksort
    files = [
      ".cache/keepassxc/keepassxc.ini"
      ".config/easyeffects/db/easyeffectsrc"
      ".config/gsconnect/certificate.pem"
      ".config/gsconnect/private.pem"
      ".config/sops/age/keys.txt"
      ".config/sops/age/keys.txt"
      ".config/syncthingtray.ini"
      ".screenrc"

      /*
        ".config/distrobox/containers.ini"
        ".config/distrobox/distrobox.conf"
      */
      ".z"

      # ".config/chromium/NativeMessagingHosts"

      # ".mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"
      #".nix-defexpr/channels_root"

      #".nix-defexpr/channels"
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
