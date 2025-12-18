{
  pkgs,
  config,
  lib,
  ...
}:
/*
  let
    plugins = [

    ];
  in

{
  home.file."${config.xdg.cacheHome}/oh-my-zsh/.keep".text = "";

  home.persistence."/persist/home/egor" = {
    directories = [
      ".cache/oh-my-zsh"
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
  ];

  home.shell = {
    enableZshIntegration = true;
  };
  programs = {
    /*
      nix-index = {
         enable = true;
         enableZshIntegration = true;
       };
    */
    zsh = {
      enable = true;
      #autocd = true;
      envExtra = ''
        umask 077
      '';
      dotDir = "${config.xdg.configHome}/zsh";
      #autosuggestion.enable = true;
      #enableCompletion = true;
      #enableVteIntegration = true;
      #syntaxHighlighting.enable = true;
      /*
        extraConfig = ''
             $env.config.hooks.command_not_found = source ${pkgs.nix-index}/etc/profile.d/command-not-found.zsh
           '';
      */
      initContent = lib.mkMerge [
        (lib.mkBefore ''
          #POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
          #source ~/.p10k.zsh



          # Powerlevel10k Zsh theme  
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme  
          test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh 


          HISTDB_FILE=''${XDG_DATA_HOME-$HOME/.local/share}/zsh/history.db

          # Do this early so fast-syntax-highlighting can wrap and override this
          if autoload history-search-end; then
            zle -N history-beginning-search-backward-end history-search-end
            zle -N history-beginning-search-forward-end  history-search-end
          fi
          autoload -Uz compinit && compinit
          autoload -U colors && colors
          alias ls='ls -G'

          # history
          setopt share_history
          bindkey '^[[A' history-beginning-search-backward
          bindkey '^[[B' history-beginning-search-forward

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

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
          {
            name = "romkatv/powerlevel10k";
            tags = [
              "as:theme"
              "depth:1"
            ];
          } # Installations with additional options. For the list of options, please refer to Zplug README.
          #{ name = "powerlevel10k-config"; }
          { name = "autojump"; }
          { name = "git"; }
          { name = "colored-man-pages"; }
          { name = "woefe/wbase.zsh"; }
          { name = "junegunn/fzf"; }
          { name = "junegunn/fzf-bin"; }
          {
            name = "sharkdp/fd";
            tags = [
              "from:gh-r"
              "as:command"
              "rename-to:fd" # "use"="*x86_64-unknown-linux-gnu.tar.gz"
            ];
          }
          { name = "zsh-users/zsh-completions"; }
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/history"; }
          {
            name = " zsh-users/zsh-syntax-highlighting ";
            tags = [ "defer:2" ];
          }
          {
            name = "zsh-users/zsh-history-substring-search";
            tags = [ "defer:3" ];
          }
        ];
      };

      /*
        completionInit = ''

           '';
      */

    };
  };

  /*
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  */
  #programs.starship.configPath

  programs.starship.enableInteractive = true;

  programs.starship.enableTransience = true;
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.settings = {
    add_newline = false;
    format = lib.concatStrings [
      "$line_break"
      "$package"
      "$line_break"
      "$character"
    ];
    scan_timeout = 10;
    character = {
      success_symbol = "➜";
      error_symbol = "➜";
    };
  };
}
