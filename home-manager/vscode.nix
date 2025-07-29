{ pkgs, config, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    #mutableExtensionsDir = false;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          # Themes

          # Visuals
          pkief.material-icon-theme
          # NixOS
          jnoortheen.nix-ide

          signageos.signageos-vscode-sops

          #pinage404.nix-extension-pack

          #arrterian.nix-env-selector
        ];
        userSettings = {
          "editor.inlayHints.enabled" = "on";
          "editor.guides.indentation" = true;
          "editor.guides.bracketPairs" = true;
          "editor.wordWrap" = "off";
          "diffEditor.wordWrap" = "off";
          # "blockman.n33A01B2FromDepth0ToInwardForAllBackgrounds" = "10,0,0,1; none";

          "workbench.colorCustomizations" = {
            "editor.lineHighlightBorder" = "#4cd3081a";
            "editor.lineHighlightBackground" = "#e22d0031";
          };

          /*
            "blockman.n04Sub02ColorComboPresetForLightTheme" = "none";
            "blockman.n23AnalyzeSquareBrackets" = true;
          */
          "workbench.iconTheme" = "material-icon-theme";

          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = false;
        };
      };
      HTML = {

        extensions =
          pkgs.nix4vscode.forVscode
            # with pkgs.nix4vscode.forVscode;
            [
              # Themes

              # Visuals
              "pkief.material-icon-theme"
              # NixOS
              "arrterian.nix-env-selector"
              "mkhl.direnv"
              # Core
              "ecmel.vscode-html-css"
              "hansuxdev.bootstrap5-snippets"

              "pranaygp.vscode-css-peek"
            ];

        userSettings = {
          "editor.inlayHints.enabled" = "on";
          "editor.guides.indentation" = true;
          "editor.guides.bracketPairs" = true;
          "editor.wordWrap" = "off";
          "diffEditor.wordWrap" = "off";
          # "blockman.n33A01B2FromDepth0ToInwardForAllBackgrounds" = "10,0,0,1; none";

          "workbench.colorCustomizations" = {
            "editor.lineHighlightBorder" = "#4cd3081a";
            "editor.lineHighlightBackground" = "#e22d0031";
          };

          /*
            "blockman.n04Sub02ColorComboPresetForLightTheme" = "none";
            "blockman.n23AnalyzeSquareBrackets" = true;
          */
          "workbench.iconTheme" = "material-icon-theme";

          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = false;
        };
      };
      Hugo = {
        extensions = with pkgs.vscode-extensions; [
          # Themes

          # Visuals
          pkief.material-icon-theme
          # NixOS
          jnoortheen.nix-ide

          signageos.signageos-vscode-sops

          #pinage404.nix-extension-pack

          #arrterian.nix-env-selector
        ];
        userSettings = {
          "editor.inlayHints.enabled" = "on";
          "editor.guides.indentation" = true;
          "editor.guides.bracketPairs" = true;
          "editor.wordWrap" = "off";
          "diffEditor.wordWrap" = "off";
          # "blockman.n33A01B2FromDepth0ToInwardForAllBackgrounds" = "10,0,0,1; none";

          "workbench.colorCustomizations" = {
            "editor.lineHighlightBorder" = "#4cd3081a";
            "editor.lineHighlightBackground" = "#e22d0031";
          };

          /*
            "blockman.n04Sub02ColorComboPresetForLightTheme" = "none";
            "blockman.n23AnalyzeSquareBrackets" = true;
          */
          "workbench.iconTheme" = "material-icon-theme";

          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = false;
        };
      };
      Python = {
        extensions = with pkgs.vscode-extensions; [
          # Themes

          # Visuals
          pkief.material-icon-theme
          # NixOS
          jnoortheen.nix-ide

          signageos.signageos-vscode-sops

          #pinage404.nix-extension-pack

          #arrterian.nix-env-selector
        ];
        userSettings = {
          "editor.inlayHints.enabled" = "on";
          "editor.guides.indentation" = true;
          "editor.guides.bracketPairs" = true;
          "editor.wordWrap" = "off";
          "diffEditor.wordWrap" = "off";
          # "blockman.n33A01B2FromDepth0ToInwardForAllBackgrounds" = "10,0,0,1; none";

          "workbench.colorCustomizations" = {
            "editor.lineHighlightBorder" = "#4cd3081a";
            "editor.lineHighlightBackground" = "#e22d0031";
          };

          /*
            "blockman.n04Sub02ColorComboPresetForLightTheme" = "none";
            "blockman.n23AnalyzeSquareBrackets" = true;
          */
          "workbench.iconTheme" = "material-icon-theme";

          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = false;
        };
      };
    };
  };

  /*
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
  */

}
