/*
  {
    pkgs,
    lib,
    stdenv,
    fetchFromGitHub,
  }:

  stdenv.mkDerivation {
    meta = with pkgs.lib; {
      description = "OSC Hotkey Daemon";
      homepage = "https://demonastery.org";
      license = licenses.free;
    };
    src = fetchFromGitHub {
      owner = "jeffshee";
      repo = "gnome-ext-hanabi";
      rev = "0a607bcce5e64cba0b7a578db350224b8df18c41";
      hash = "sha256-EvfDUdd0m4smXV0VLVIXTNCvDY5ZCH3zSY14/174kJc=";
    }; # NURL IS AWESOME

    pname = "gnome-ext-hanabi";
    version = "git";

    buildInputs = with pkgs; [

    ];
    #out = ./.;

    doCheck = true;

    installPhase = ''
      rm -rf .build
      meson setup .build --prefix=$HOME/.local/ && ninja -C .build install

      lmkdir -p $out/bin
      mv chord $out/bin
    '';
  }
*/

#with import /nix/nixpkgs { };
{
  fetchFromGitHub,
  coreutils,
  stdenv,
  glib,
}:
stdenv.mkDerivation {
  name = "gnome-ext-hanabi";
  src = fetchFromGitHub {
    owner = "jeffshee";
    repo = "gnome-ext-hanabi";
    rev = "0a607bcce5e64cba0b7a578db350224b8df18c41";
    hash = "sha256-EvfDUdd0m4smXV0VLVIXTNCvDY5ZCH3zSY14/174kJc=";
  }; # NURL IS AWESOME
  dontUnpack = true;
  nativeBuildDependencies = [
    coreutils
    glib.dev
  ];
  buildPhase = ''
    ${coreutils}/bin/md5sum /bin/sh
  '';
  #dontInstall = true;
}
