# nix-build -E 'with import <nixpkgs> { }; callPackage ./default.nix { }'

{
  stdenv,
  lib,
  bash,
  subversion,
  makeWrapper,
}:
let
  fs = lib.fileset;
in
stdenv.mkDerivation {
  pname = "fs-diff";
  version = "1.0";

  src = fs.toSource {
    root = ./.;
    fileset = ./fs-diff.sh;
  };

  buildInputs = [
    bash
    subversion
  ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp fs-diff.sh $out/bin/fs-diff.sh
    wrapProgram $out/bin/fs-diff.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          subversion
        ]
      }
  '';
}
