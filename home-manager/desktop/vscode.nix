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
  baseSettings = {
    "editor.inlayHints.enabled" = "on";
    "editor.guides.indentation" = true;
    "editor.guides.bracketPairs" = true;
    "editor.wordWrap" = "off";
    "diffEditor.wordWrap" = "off";
    # "blockman.n33A01B2FromDepth0ToInwardForAllBackgrounds" = "10,0,0,1; none";
    #"editor.fontFamily" = "Operator Mono, Menlo, Monaco, 'Courier New', monospace";
    #"terminal.integrated.fontFamily" = "'Operator Mono', 'Inconsolata for Powerline', monospace";
    #"editor.fontSize" = 17;
    "editor.lineHeight" = 24.65;
    "editor.letterSpacing" = 0.5;
    "editor.fontWeight" = "400";
    "editor.fontLigatures" = true;
    "editor.cursorStyle" = "line";
    "editor.cursorWidth" = 5;
    "editor.cursorBlinking" = "solid";
    #"editor.renderWhitespace" = "all";

    "editor.snippetSuggestions" = "top";
    "workbench.startupEditor" = "newUntitledFile";
    "editor.glyphMargin" = true;
    "workbench.editor.enablePreview" = false;
    "explorer.confirmDragAndDrop" = false;
    "files.trimTrailingWhitespace" = true;
    "files.trimFinalNewlines" = true;
    "workbench.colorCustomizations" = {
      "editor.lineHighlightBorder" = "#4cd3081a";
      "editor.lineHighlightBackground" = "#e22d0031";
    };
    "workbench.iconTheme" = "material-icon-theme";

    "editor.formatOnSave" = true;
    "editor.formatOnPaste" = false;
    "window.newWindowProfile" = "Default";
    #"workbench.editor.limit" = 5;
    "git.enableSmartCommit" = true;
    "git.autofetch" = true;
    "git.confirmSync" = false;

    "explorer.confirmDelete" = false;

    "vscode-pets.petColor" = "black";
    "vscode-pets.petSize" = "large";
    "vscode-pets.position" = "explorer";
    #"vscode-pets.theme" = "forest";
    #"vscode-pets.throwBallWithMouse" = false;

    #"nixEnvSelector.nixFile" = null; # Path to the Nix config file
    #"nixEnvSelector.packages" = [ ]; # List packages using as -p nix-shell args
    "nixEnvSelector.args" = null; # Custom args string for nix-shell. EX: -A <something> --pure
    #"nixEnvSelector.nixShellPath" = null; # Custom path for nix-shell executable
    "nixEnvSelector.useFlakes" = true;
  };
  baseExtensions = [
    "pkief.material-icon-theme"
    "tonybaloney.vscode-pets"
    "codeandstuff.vscode-navigate-edit-history"
    "pnw-techpros.code-casefile"
    "paragdiwan.gitpatch"
    "visbydev.folder-path-color"

    "mkhl.direnv"
    #"arrterian.nix-env-selector"

    "jnoortheen.nix-ide"

    1nvitr0.blocksort

  ];
  baseExtensionsVS = [

  ];

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
          forOpenVsx [

            # NixOS
            "jnoortheen.nix-ide"

            "signageos.signageos-vscode-sops"
            "jeff-hykin.better-nix-syntax"

            #"folke.vscode-monorepo-workspace"
            #"moshfeu.compare-folders"
            #pinage404.nix-extension-pack

            #arrterian.nix-env-selector
          ]
          ++ forOpenVsx baseExtensions
          ++ forVscode [ ]
          ++ forVscode baseExtensionsVS;

        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil"; # or "nil"
          # LSP config can be passed via the ``nix.serverSettings.{lsp}`` as shown below.

          "nix.serverSettings" = {
            "nil" = {
              "diagnostics" = {
                "ignored" = [
                  "unused_binding"
                  "unused_with"
                ];
              };
              /*
                "formatting" = {
                             "command" = [
                               "treefmt"
                               "--stdin"
                               "{file}"
                             ];
                           };
              */
            };
            # check https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md for all nixd config
            /*
              "nixd" = {
                "nixpkgs" = {
                  # For flake.
                  #"expr" = "import (builtins.getFlake \"/home/egor/my-little-flake\").inputs.nixpkgs { }   ";

                  # This expression will be interpreted as "nixpkgs" toplevel
                  # Nixd provides package, lib completion/information from it.
                  #/
                  # Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
                  #/                Package documentation, versions, are evaluated by-need.
                  "expr" = "import <nixpkgs> { }";
                };
                "formatting" = {
                  # Which command you would like to do formatting
                  "command" = [ "nixfmt" ];
                };
                # Tell the language server your desired option set, for completion
                # This is lazily evaluated.
                "options" = {
                  # Map of eval information
                  # By default, this entriy will be read from `import <nixpkgs> { }`
                  # You can write arbitary nix expression here, to produce valid "options" declaration result.
                  #
                  # *NOTE*: Replace "<name>" below with your actual configuration name.
                  # If you're unsure what to use, you can verify with `nix repl` by evaluating
                  # the expression directly.
                  #
                  "nixos" = {
                    "expr" = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.stellar.options";
                  };

                  # Before configuring Home Manager options, consider your setup:
                  # Which command do you use for home-manager switching?
                  #
                  #  A. home-manager switch --flake .#... (standalone Home Manager)
                  #  B. nixos-rebuild switch --flake .#... (NixOS with integrated Home Manager)
                  #
                  # Configuration examples for both approaches are shown below.
                  "home-manager" = {
                    # A:
                    #"expr"= "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.<name>.options"

                    # B:
                    "expr" =
                      "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.stellar.options.home-manager.users.type.getSubOptions []";
                  };
                };
              };
            */
          };
          "nix.hiddenLanguageServerErrors" = [
            "  Code: -32603 "
          ];

        }
        // baseSettings;

      };
      HTML = {
        extensions =
          forOpenVsx [
            # NixOS
            "arrterian.nix-env-selector"
            "mkhl.direnv"
            # Core
            "ecmel.vscode-html-css"
            "antfu.browse-lite"
            #"hansuxdev.bootstrap5-snippets"

            "pranaygp.vscode-css-peek"
          ]
          ++ forOpenVsx baseExtensions
          ++ forVscode [ ]
          ++ forVscode baseExtensionsVS;

        userSettings = {
          "browse-lite.chromeExecutable" = "chromiun";
        }
        // baseSettings;

      };
      Hugo = {
        extensions =
          forOpenVsx [
            # Themes

            "ahmadawais.shades-of-purple"

            #pinage404.nix-extension-pack
            "fivethree.vscode-hugo-snippets"
            "budparr.language-hugo-vscode"
            "rusnasonov.vscode-hugo"
            "unifiedjs.vscode-mdx"
            "astro-build.astro-vscode"
            "phoenisx.cssvar"
            "arrterian.nix-env-selector"

            #arrterian.nix-env-selector
          ]
          ++ forOpenVsx baseExtensions
          ++ forVscode [ ]
          ++ forVscode baseExtensionsVS;
        userSettings = {
          # Theme Setup.
          "workbench.colorTheme" = "Shades of Purple";

          # Formatting Optional.
          "editor.formatOnSave" = true;
          "prettier.eslintIntegration" = true;
          "eslint.run" = "onType";
          "editor.codeActionsOnSave" = {
            "source.fixAll.eslint" = true;
          };
          # MacOS Only Settings.
          "workbench.fontAliasing" = "auto";
          "terminal.integrated.macOptionIsMeta" = true;
          "workbench.statusBar.feedback.visible" = false;
          # The default syntax (TextMate) highlighter classifies many tokens as variables and these are now (since VSCode 1.43) resolved into namespaces, classes, parameters, and so on. This is called Semantic highlighting support for TypeScript and JavaScript. But many themes and language extensions seem broken with single-colored syntax. This came as a surprise to me. It's set `true` by default. I recommend disabling this for now.
          "editor.semanticHighlighting.enabled" = false;
          # SOP's highlight matching tag setting.
          "highlight-matching-tag.styles" = {
            "opening" = {
              "full" = {
                "highlight" = "rgba(165, 153, 233, 0.3)";
              };
            };
          };
          # SOP's Import Cost Extension Settings.
          "importCost.largePackageColor" = "#EC3A37F5";
          "importCost.mediumPackageColor" = "#B362FF";
          "importCost.smallPackageColor" = "#B362FF";
          "nixEnvSelector.useFlakes" = true;

        }
        // baseSettings;
      };
      Python = {
        extensions =
          forOpenVsx [
            "wesbos.theme-cobalt2"
            "signageos.signageos-vscode-sops"
            "mkhl.direnv"

            #Stuff
            "ms-python.python"
            "ms-python.debugpy"
            #"redhat.vscode-xml"
            #"prateekmahendrakar.prettyxml"
            "dotjoshjohnson.xml"
            "kevinrose.vsc-python-indent"
            #"ms-python.black-formatter"
            "charliermarsh.ruff"

            #"github.copilot"
            #"folke.vscode-monorepo-workspace"

            #"trinhanhngoc.vscode-odoo"

            #arrterian.nix-env-selector
          ]
          ++ forOpenVsx baseExtensions
          ++ forVscode [ ]
          ++ forVscode baseExtensionsVS;
        userSettings = {
          # This is all that matters
          "workbench.colorTheme" = "Cobalt2";
          #"telemetry.enableTelemetry" = false;
        }
        // baseSettings;
      };
      C = {
        extensions =
          forOpenVsx [
            #"signageos.signageos-vscode-sops"
            "mkhl.direnv"

            "llvm-vs-code-extensions.vscode-clangd"
            #"kylinideteam.cppdebug"

            "babyfox1306.pdf-forge"
            "kube.42header"
            #"mariusvanwijk-joppekoers.codam-norminette-3"
            "brittanychiang.halcyon-vscode"
            "farrese.midas"
            "ms-vscode.cmake-tools"

            "danielpinto8zz6.c-cpp-project-generator"
            "franneck94.vscode-c-cpp-config"
            "harry-ross-software.c-snippets"
            "vadimcn.vscode-lldb"
          ]
          ++ forOpenVsx baseExtensions
          ++ forVscode [
            #"keyhr.42-c-format"
          ]
          ++ forVscode baseExtensionsVS;
        userSettings = {

          # This is all that matters
          "workbench.colorTheme" = "Halcyon";

          "editor.renderWhitespace" = "all";

          /*
            "[c]" = {
                     "editor.defaultFormatter" = "keyhr.42-c-format";
                   };
          */
          "material-icon-theme.folders.color" = "#8695b7";
          "material-icon-theme.folders.theme" = "specific";
          "material-icon-theme.hidesExplorerArrows" = true;

          "nixEnvSelector.nixFile" = null; # Path to the Nix config file
          "nixEnvSelector.packages" = [ ]; # List packages using as -p nix-shell args
          "nixEnvSelector.args" = null; # Custom args string for nix-shell. EX: -A <something> --pure
          #"nixEnvSelector.nixShellPath" = null; # Custom path for nix-shell executable
        }
        // baseSettings;
      };
      Bash = {
        extensions =
          forOpenVsx [

            "formulahendry.code-runner"

            "foxundermoon.shell-format"
            "jeff-hykin.better-shellscript-syntax"
            "mads-hartmann.bash-ide-vscode" # bash-language-server
            "rogalmic.bash-debug"
            "rpinski.shebang-snippets"
            "jeff-hykin.better-shellscript-syntax"
            "timonwong.shellcheck"

          ]
          ++ forOpenVsx baseExtensions
          ++ forVscode [
            #"keyhr.42-c-format"
          ]
          ++ forVscode baseExtensionsVS;
        userSettings = {

          # This is all that matters
          "workbench.colorTheme" = "Halcyon";

          "editor.renderWhitespace" = "all";

          /*
            "[c]" = {
                     "editor.defaultFormatter" = "keyhr.42-c-format";
                   };
          */
          "material-icon-theme.folders.color" = "#8695b7";
          "material-icon-theme.folders.theme" = "specific";
          "material-icon-theme.hidesExplorerArrows" = true;

          "code-runner.executorMap" = {
            javascript = "node";
            php = "C:\\php\\php.exe";
            python = "python";
            perl = "perl";
            ruby = "C:\\Ruby23-x64\\bin\\ruby.exe";
            go = "go run";
            html = "\"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe\"";
            java = "cd $dir && javac $fileName && java $fileNameWithoutExt";
            c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt";
          };

          "shellcheck.enable" = true;
          "shellcheck.enableQuickFix" = true;
          "shellcheck.run" = "onType";
          "shellcheck.executablePath" = "";
          "shellcheck.exclude" = [

          ];
          "shellcheck.customArgs" = [

          ];
          "shellcheck.ignorePatterns" = {
            "**/*.csh" = true;
            "**/*.cshrc" = true;
            "**/*.fish" = true;
            "**/*.login" = true;
            "**/*.logout" = true;
            "**/*.tcsh" = true;
            "**/*.tcshrc" = true;
            "**/*.xonshrc" = true;
            "**/*.xsh" = true;
            "**/*.zsh" = true;
            "**/*.zshrc" = true;
            "**/zshrc" = true;
            "**/*.zprofile" = true;
            "**/zprofile" = true;
            "**/*.zlogin" = true;
            "**/zlogin" = true;
            "**/*.zlogout" = true;
            "**/zlogout" = true;
            "**/*.zshenv" = true;
            "**/zshenv" = true;
            "**/*.zsh-theme" = true;
          };
          "shellcheck.ignoreFileSchemes" = [
            "git"
            "gitfs"
            "output"
          ];
        }
        // baseSettings;
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
