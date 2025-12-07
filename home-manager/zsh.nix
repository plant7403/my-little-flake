{ pkgs, config, ... }:
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
      ".cache/nix-index"
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
  ];
  /*
    programs.nushell = {
      enable = true;
      extraConfig = ''
        $env.config.hooks.command_not_found = source ${pkgs.nix-index}/etc/profile.d/command-not-found.nu
      '';
    };
  */
  home.shell = {
    enableZshIntegration = true;
  };
  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      autocd = true;
      #dotDir = "${config.xdg.configHome}/zsh";
      autosuggestion.enable = true;
      enableCompletion = true;
      #enableVteIntegration = true;
      #syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "autojump"
          "git"
          "colored-man-pages"
          "zsh-interactive-cd"
          "history"
          "history-substring-search"

          # "nix-zsh-completions"
          "fzf"
        ];
      };
      /*
        completionInit = ''

        '';

        initContent = ''
          POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
        '';
      */

    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
