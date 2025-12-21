{
  programs.ghostty = {
    clearDefaultKeybinds = false;
    enable = true;
    enableZshIntegration = true;
    installVimSyntax = true;
    settings = {
      #theme = "catppuccin-mocha";
      font-size = 12;
      background = "282c34";
      foreground = "ffffff";
      keybind = [
        "ctrl+h=goto_split:left"
        "ctrl+l=goto_split:right"
        "ctrl+z=close_surface"
        "ctrl+d=new_split:right"
      ];
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "15m";

      mouse-shift-capture = "true";

      # Transparency
      background-opacity = 0.75;
      background-blur-radius = 0;
      alpha-blending = "native";
      window-colorspace = "display-p3";
      window-padding-x = 12;
      window-padding-y = "12,6";
      window-padding-balance = true;

    };
    systemd.enable = true;
  };
}
