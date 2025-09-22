{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    pay-respects
    mosh
    tmux
  ];
  home.shell.enableZshIntegration = true;
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;
    #enableVteIntegration = true;
    #syntaxHighlighting.enable = true;

    initContent = ''
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };
  };
}
