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
*/
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
          POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

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
          {"powerlevel10k-config"}
          { name = "autojump"; }
          { name = "git"; }
          { name = "colored-man-pages"; }
          { name = "history"; }
          { name = "history-substring-search"; }
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
}
