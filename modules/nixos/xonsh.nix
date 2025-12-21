{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.xonsh;
in
{
  options.modules.xonsh = {
    enable = mkEnableOption "service";
  };

  config = {
    programs.xonsh = {
      config = ''

      '';
      enable = true;
      bashCompletion.enable = true;
      extraPackages = ps: [
        #setuptools
        ps.numpy
        ps.xonsh.xontribs.xontrib-vox
        #xonsh.xontribs.gitinfo
        #xonsh.xontribs.prompt_starship
        #xonsh.xontribs.zoxide
        ps.xonsh.xontribs.xontrib-fish-completer
        /*
          xonsh.xontribs.xontrib-z
          xonsh.xontribs.xontrib-hist_navigator
          xonsh.xontribs.xontrib-dir-picker
          xonsh.xontribs.xontrib-coreutils
          xonsh.xontribs.xontrib-carapace-bin
          xonsh.xontribs.xontrib-jedi
          xonsh.xontribs.xontrib-argcomplete
          xonsh.xontribs.xontrib-whole-word-jumping
          xonsh.xontribs.xontrib-direnv
        */
        ps.xonsh.xontribs.xontrib-prompt-starship
      ];
      package = pkgs.xonsh.override {
        extraPackages = ps: [
          (ps.buildPythonPackage rec {
            name = "xontrib-fish-completer";
            version = "0.0.1";

            src = pkgs.fetchFromGitHub {
              owner = "xonsh";
              repo = "${name}";
              rev = "${version}";
              sha256 = "PhhdZ3iLPDEIG9uDeR5ctJ9zz2+YORHBhbsiLrJckyA=";
            };

            meta = {
              homepage = "https://github.com/xonsh/xontrib-fish-completer";
              description = "Populate rich completions using fish and remove the default bash based completer";
              license = pkgs.lib.licenses.mit;
              maintainers = [ ];
            };

            prePatch = ''
              pkgs.lib.substituteInPlace pyproject.toml --replace '"xonsh>=0.12.5"' ""
            '';
            patchPhase = "sed -i -e 's/^dependencies.*$/dependencies = []/' pyproject.toml";
            doCheck = false;
          })
          (ps.buildPythonPackage rec {
            name = "xontrib-zoxide";
            version = "v1.0.0";
            format = "pyproject";
            src = pkgs.fetchFromGitHub {
              owner = "dyuri";
              repo = "${name}";
              rev = "${version}";
              sha256 = "9xAR2R7IwGttv84qVb+8TkW6OAK6OGLW3o/tDQnUwII=";
            };
            nativeBuildInputs = [
              pkgs.python3Packages.pip
              pkgs.python3Packages.poetry-core
            ];
            meta = {
              homepage = "https://github.com/dyuri/xontrib-zoxide";
              description = "Zoxide support for xonsh";
              license = pkgs.lib.licenses.mit;
              maintainers = [ ];
            };
          })
          (ps.buildPythonPackage rec {
            name = "xontrib-prompt-starship";
            version = "dd9262fdfcd256408b881952339db84c8b29da8d";
            format = "pyproject";
            src = pkgs.fetchFromGitHub {
              owner = "anki-code";
              repo = "${name}";
              rev = "${version}";
              sha256 = "LIqwlbn3XsbdJ1wT7Q+9Ex2heIq6EIDPCWUNLVn3N5k=";
            };
            nativeBuildInputs = [
              pkgs.python3Packages.pip
              pkgs.python3Packages.poetry-core
            ];
            meta = {
              homepage = "https://github.com/anki-code/xontrib-prompt-starship";
              description = "Zoxide support for xonsh";
              license = pkgs.lib.licenses.mit;
              maintainers = [ ];
            };
          })
        ];
      };
    };
    programs.zoxide.enableXonshIntegration = true;
    programs.direnv.enableXonshIntegration = true;
  };
}
