{ pkgs, config, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    #mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      # Themes
      #dracula-theme.theme-dracula
      #ahmadawais.shades-of-purple
      # Visuals
      pkief.material-icon-theme
      # NixOS
      jnoortheen.nix-ide


      signageos.signageos-vscode-sops


      #pinage404.nix-extension-pack

      #arrterian.nix-env-selector
    ];
    userSettings = {
      "editor.inlayHints.enabled" = "off";
      "editor.guides.indentation" = false;
      "editor.guides.bracketPairs" = false;
      "editor.wordWrap" = "off";
      "diffEditor.wordWrap" = "off";
      "blockman.n33A01B2FromDepth0ToInwardForAllBackgrounds" = "10,0,0,1; none";

      "workbench.colorCustomizations" = {
        "editor.lineHighlightBorder" = "#4cd3081a";
        "editor.lineHighlightBackground" = "#e22d0031";
      };
      "blockman.n04Sub02ColorComboPresetForLightTheme" = "none";
      "blockman.n23AnalyzeSquareBrackets" = true;
      "workbench.iconTheme" = "material-icon-theme";
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
    };
  };
  home.activation.makeVSCodeConfigWritable =
    let
      configDirName =
        {
          "vscode" = "Code";
          "vscode-insiders" = "Code - Insiders";
          "vscodium" = "VSCodium";
        }.${config.programs.vscode.package.pname};
      configPath = "${config.xdg.configHome}/${configDirName}/User/settings.json";
    in
    {
      after = [ "writeBoundary" ];
      before = [ ];
      data = ''
        install -m 0640 "$(readlink ${configPath})" ${configPath}
      '';
    };

}
