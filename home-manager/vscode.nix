# https://nix-community.github.io/nix4vscode/
{ pkgs, config, ... }:
let
  inherit (pkgs.nix4vscode)
    forVscode
    forVscodeVersion
    forVscodePrerelease
    forVscodeVersionPrerelease

    forOpenVsx
    forOpenVsxVersion
    forOpenVsxPrerelease
    forOpenVsxVersionPrerelease

    forVscodeExt
    forVscodeExtVersion
    forVscodeExtPrerelease
    forVscodeExtVersionPrerelease

    forOpenVsxExt
    forOpenVsxExtVersion
    forOpenVsxExtPrerelease
    forOpenVsxExtVersionPrerelease
    ;

  myDecorators = {
    "ms-vscode.cpptools" = {
      postPatch = ''
        echo "Custom decorator applied"
      '';
    };
  };
in
{
  /*
    home.packages = with pkgs; [
      (vscodium.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          substituteInPlace $out/lib/vscode/resources/app/product.json \
            --replace \
            '    "GitHub.copilot": ["inlineCompletionsAdditions"],' \
            '    "GitHub.copilot": ["inlineCompletions","inlineCompletionsNew","inlineCompletionsAdditions","textDocumentNotebook","interactive","terminalDataWriteEvent"],'
        '';
      }))
    ];
  */

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    #mutableExtensionsDir = false;
    profiles = {
      default = {
        extensions =
          forVscode [
            # Themes

            # Visuals
            "pkief.material-icon-theme"
            # NixOS
            "jnoortheen.nix-ide"
            "jeff-hykin.better-nix-syntax"

            "signageos.signageos-vscode-sops"
            "jeff-hykin.better-nix-syntax"
            "moshfeu.compare-folders"
            #pinage404.nix-extension-pack

            #arrterian.nix-env-selector
          ]
          ++ forOpenVsx [ ];

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
          "window.newWindowProfile" = "Default";

        };
      };
      HTML = {
        extensions =
          forVscode [
            # with pkgs.nix4vscode.forVscode;

            # Themes

            # Visuals
            "pkief.material-icon-theme"
            # NixOS
            "arrterian.nix-env-selector"
            "mkhl.direnv"
            # Core
            "ecmel.vscode-html-css"
            "antfu.browse-lite"
            #"hansuxdev.bootstrap5-snippets"

            "pranaygp.vscode-css-peek"
          ]
          ++ forOpenVsx [ ];

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

          "browse-lite.chromeExecutable" = "chromiun";
        };
      };
      Hugo = {
        extensions =
          forVscode [
            # Themes

            # Visuals
            "pkief.material-icon-theme"
            # NixOS
            "jnoortheen.nix-ide"

            "signageos.signageos-vscode-sops"

            #pinage404.nix-extension-pack

            #arrterian.nix-env-selector
          ]
          ++ forOpenVsx [ ];
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
        extensions =
          forVscode [
            # Themes
            "wesbos.theme-cobalt2"

            # Visuals
            "pkief.material-icon-theme"
            "tonybaloney.vscode-pets"

            # NixOS
            #"jnoortheen.nix-ide"
            "signageos.signageos-vscode-sops"
            "mkhl.direnv"

            #Stuff
            "ms-python.python"
            "ms-python.debugpy"
            #"redhat.vscode-xml"
            #"prateekmahendrakar.prettyxml"
            "dotjoshjohnson.xml"
            "kevinrose.vsc-python-indent"
            "ms-python.black-formatter"
            "charliermarsh.ruff"

            "github.copilot"

            #"trinhanhngoc.vscode-odoo"
            #pinage404.nix-extension-pack

            #arrterian.nix-env-selector
          ]
          ++ forOpenVsx [ ];
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
          "redhat.telemetry.enabled" = false;

          /*
            "blockman.n04Sub02ColorComboPresetForLightTheme" = "none";
            "blockman.n23AnalyzeSquareBrackets" = true;
          */

          # This is all that matters
          "workbench.colorTheme" = "Cobalt2";
          # The Cursive font is operator Mono, it's $200 and you need to buy it to get the cursive. Dank Mono or Victor Mono are good alternatives
          "editor.fontFamily" = "Operator Mono, Menlo, Monaco, 'Courier New', monospace";
          "editor.fontSize" = 17;
          "editor.lineHeight" = 25;
          "editor.letterSpacing" = 0.5;
          "files.trimTrailingWhitespace" = true;
          "editor.fontWeight" = "400";
          "prettier.eslintIntegration" = true;
          "editor.cursorStyle" = "line";
          "editor.cursorWidth" = 5;
          "editor.cursorBlinking" = "solid";
          "editor.renderWhitespace" = "all";
          "workbench.iconTheme" = "material-icon-theme";

          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = false;

          "vscode-pets.petColor" = "black";
          "vscode-pets.petSize" = "large";
          "vscode-pets.position" = "explorer";
          #"vscode-pets.theme" = "forest";
          #"vscode-pets.throwBallWithMouse" = false;
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
