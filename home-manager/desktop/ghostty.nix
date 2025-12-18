{
  programs.ghostty = {
    clearDefaultKeybinds = false;
    enable = true;
    enableZshIntegration = true;
    #installVimSyntax = true;
    settings = {
      #theme = "catppuccin-mocha";
      font-size = 10;
      keybind = [
        "ctrl+h=goto_split:left"
        "ctrl+l=goto_split:right"
      ];
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "5m";
    };
    systemd.enable = true;
  };
}
