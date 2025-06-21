{pkgs, ...}: {
  home.packages = with pkgs; [
    pay-respects
    mosh
    tmux
  ];
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;

    initExtra = ''
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "pay-respects"
      ];
      theme = "robbyrussell";
    };
  };
}
