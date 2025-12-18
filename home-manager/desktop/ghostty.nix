{
  programs.ghostty = {
    clearDefaultKeybinds = false;
    enable = true;
    enableZshIntegration = true;
    #installVimSyntax = true;
    settings = {
      #theme = "catppuccin-mocha";
      font-size = 12;
      background = 282c34;
      foreground = "ffffff";
      keybind = [
        "ctrl+h=goto_split:left"
        "ctrl+l=goto_split:right"
      ];
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "15m";
    };
    systemd.enable = true;
  };
}
