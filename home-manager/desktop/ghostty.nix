{
  programs.ghostty = {
    clearDefaultKeybinds = false;
    enable = true;
    enableZshIntegration = true;
    installVimSyntax = true;
    settings = {
      #theme = "catppuccin-mocha";
      font-size = 10;
      keybind = [
        "ctrl+h=goto_split:left"
        "ctrl+l=goto_split:right"
      ];
    };
    systemd.enable = true;
  };
}
