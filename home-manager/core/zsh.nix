{
  pkgs,
  config,
  lib,
  ...
}:
{
  #home.file."${config.xdg.cacheHome}/oh-my-zsh/.keep".text = "";

  home.persistence."/persist/home/egor" = {
    directories = [
      #".cache/oh-my-zsh"
      # ".cache/nix-index"
    ];
    files = [
      ".config/zsh/.zsh_history"
      ".zsh_history"
    ];
  };

  home.packages = with pkgs; [
    mosh
    tmux
    zsh-bd
    fzf
    autojump
    sqlite-interactive
    zoxide
  ];
  programs.man = {
    enable = true;
    generateCaches = true; # will take little time
  };
  programs.btop = {
    enable = true;
    settings = {
      # color_theme = "default";
      theme_background = false;
      vim_keys = true;
      shown_boxes = "proc cpu";
      rounded_corners = true;
      graph_symbol = "block";
      proc_sorting = "memory";
      proc_reversed = false;
      proc_gradient = true;
    };
  };
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
  };
  programs.zoxide = {
    enableZshIntegration = true;
  };
  home.shell = {
    enableZshIntegration = true;
  };
  programs = {
    zsh = {
      enable = true;
      envExtra = ''
        umask 077
      '';
      #dotDir = "${config.xdg.configHome}/zsh";
      autosuggestion.enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      autocd = true;

      shellAliases = {
        vim = "nvim";
        ls = "ls --color";
        ctrl-l = "clear";
        C-l = "ctrl-l";
        control-l = "clear";
        clean = "clear";
        r2 = "aws --profile r2 --endpoint-url https://03af1b41c1aa6fe21d9b3a645dca423e.r2.cloudflarestorage.com";
      };

      initContent = lib.mkMerge [
        (lib.mkBefore ''
          HISTDB_FILE=''${XDG_DATA_HOME-$HOME/.local/share}/zsh/history.db

          # Do this early so fast-syntax-highlighting can wrap and override this
          if autoload history-search-end; then
            zle -N history-beginning-search-backward-end history-search-end
            zle -N history-beginning-search-forward-end  history-search-end
          fi
          autoload -Uz compinit && compinit
          autoload -U colors && colors
          #alias ls='ls -G'

          # history
          setopt share_history

          export ANSI_MOTD_ART_DIR=/home/egor/Downloads
          # globbing
          setopt extended_glob

          # zmv
          autoload -Uz zmv
          alias zcp='zmv -C'
          alias zln='zmv -L'

          # fewer keystrokes
          setopt auto_cd auto_pushd
          setopt menu_complete

          # fewer distractions
          unsetopt beep nomatch notify

          eval "$(starship init zsh)"
        '')
      ];

      history = {
        path = "\${XDG_DATA_HOME-$HOME/.local/share}/zsh/history";
        save = 1000500;
        size = 1000000;
        ignoreAllDups = true;
      };
      history.ignorePatterns = [
        "rm *"
        "pkill *"
        "cp *"
      ];
      #ANSI_MOTD_ART_DIR
      # With Oh-My-Zsh:
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "command-not-found"
          "z"
          "history"
          "systemd"
          "fzf"
        ];
      };
      plugins = [
        {
          name = "zsh-autosuggestions";
          file = "./share/zsh-autosuggestions/zsh-autosuggestions.zsh";
          src = pkgs.zsh-autosuggestions;
        }
        {
          name = pkgs.fzf-zsh.pname;
          src = pkgs.fzf-zsh.src;
        }

        {
          name = pkgs.zsh-syntax-highlighting.pname;
          src = pkgs.zsh-syntax-highlighting.src;
        }
        {
          name = pkgs.zsh-fast-syntax-highlighting.pname;
          src = pkgs.zsh-fast-syntax-highlighting.src;
        }

        {
          name = pkgs.zsh-completions.pname;
          src = pkgs.zsh-completions.src;
        }
        {
          name = pkgs.zsh-history-substring-search.pname;
          src = pkgs.zsh-history-substring-search.src;
        }

        {
          name = pkgs.zsh-histdb.pname;
          src = pkgs.zsh-histdb.src;
        }
        {
          name = "you-should-use";
          src = pkgs.fetchFromGitHub {
            owner = "MichaelAquilina";
            repo = "zsh-you-should-use";
            rev = "2be37f376c13187c445ae9534550a8a5810d4361";
            sha256 = "0yhwn6av4q6hz9s34h4m3vdk64ly6s28xfd8ijgdbzic8qawj5p1";
          };
        }
        {
          name = "async";
          file = "async.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "mafredri";
            repo = "zsh-async";
            rev = "3ba6e2d1ea874bfb6badb8522ab86c1ae272923d";
            sha256 = "3hhZXL8/Ml7UlkkHBPpS5NfUGB5BqgO95UvtpptXf8E=";
          };
        }
        {
          name = "ansimotd";
          file = "zsh-ansimotd.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "yuhonas";
            repo = "zsh-ansimotd";
            rev = "2d1e85c75c8042182fe751f105a181043c4e9929";
            hash = "sha256-VXB0JojkY9vl3iDTtjuHzDJkckK9yYf89I72La8L8v0=";
          };
        }
        {
          name = "zoxide"; # probably is already nixpkgs
          file = "zoxide.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "ajeetdsouza";
            repo = "zoxide";
            rev = "f00fe0f0aeaeaf8fda48ca467c706a5174830b77";
            hash = "sha256-7WkVyUHKpeBS1OvDL4jCwNTNl0TTNznWvtrIzACnBt8=";
          };
        }
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
        {
          name = "zoxide";
          src = pkgs.zoxide;
          file = "share/zoxide/zoxide.plugin.zsh";
        }

      ];
    };
  };

  #programs.starship.configPath

  programs.starship.enableInteractive = true;
  programs.starship.enableTransience = true;
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.settings = {
    "$schema" = "https://starship.rs/config-schema.json";
    add_newline = true;
    #scan_timeout = 5;

    line_break.disabled = false;

    hostname = {
      ssh_only = true;
      format = "[$hostname](bold blue) ";
      disabled = false;
    };

    format = lib.concatStrings [
      "[](#9A348E)"
      "$os"
      "$username"
      "[](bg:#DA627D fg:#9A348E)"
      "$directory"
      "[](fg:#DA627D bg:#FCA17D)"
      "$git_branch"
      "$git_status"
      "[](fg:#FCA17D bg:#86BBD8)"
      "$c"
      "$elixir"
      "$elm"
      "$golang"
      "$gradle"
      "$haskell"
      "$java"
      "$julia"
      "$nodejs"
      "$nim"
      "$rust"
      "$scala"
      "[](fg:#86BBD8 bg:#06969A)"
      "$docker_context"
      "[](fg:#06969A bg:#33658A)"
      /*
        "$time"
        "[ ](fg:#33658A)"
      */
    ];

    # Disable the blank line at the start of the prompt
    # add_newline = false

    # You can also replace your username with a neat symbol like   or disable this
    # and use the os module below
    username = {
      show_always = false;
      style_user = "bg:#9A348E";
      style_root = "bg:#9A348E";
      format = "[$user ]($style)";
      disabled = false;
    };

    # An alternative to the username module which displays a symbol that
    # represents the current operating system
    os = {
      style = "bg:#9A348E";
      disabled = false; # Disabled by default
    };

    directory = {
      style = "bg:#DA627D";
      format = "[ $path ]($style)";
      truncation_length = 3;
      truncation_symbol = "…/";
    };

    # Here is how you can shorten some long paths by text replacement
    # similar to mapped_locations in Oh My Posh:
    directory.substitutions = {
      "Documents" = "󰈙 ";
      "Downloads" = " ";
      "Music" = " ";
      "Pictures" = " ";
    };
    # Keep in mind that the order matters. For example:
    # "Important Documents" = " 󰈙 "
    # will not be replaced, because "Documents" was already substituted before.
    # So either put "Important Documents" before "Documents" or use the substituted version:
    # "Important 󰈙 " = " 󰈙 "

    c = {
      symbol = " ";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    cpp = {
      symbol = " ";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };

    docker_context = {
      symbol = " ";
      style = "bg:#06969A";
      format = "[ $symbol $context ]($style)";
    };

    elixir = {
      symbol = " ";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    elm = {
      symbol = " ";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    git_branch = {
      symbol = "";
      style = "bg:#FCA17D";
      format = "[ $symbol $branch ]($style)";
    };
    git_status = {
      style = "bg:#FCA17D";
      format = "[$all_status$ahead_behind ]($style)";
    };
    golang = {
      symbol = " ";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    gradle = {
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    haskell = {
      symbol = " ";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    java = {
      symbol = " ";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    julia = {
      symbol = " ";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    nodejs = {
      symbol = "";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    nim = {
      symbol = "󰆥 ";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    rust = {
      symbol = "";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    scala = {
      symbol = " ";
      style = "bg:#86BBD8";
      format = "[ $symbol ($version) ]($style)";
    };
    /*
      time = {
         disabled = false;
         time_format = "%R"; # Hour:Minute Format
         style = "bg:#33658A";
         format = "[ ♥ $time ]($style)";
       };
    */
  };
}
