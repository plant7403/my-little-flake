{
  stdenv,
  lib,
  libfprint-tod,
  pkg-config,
  meson,
  ninja,
  libfprint,
  glib,
  gusb,
  udev,
  nss,
  openssl,
  pixman,
  fetchFromGitHub,
  cmake,
  libcap,
  libseccomp,
  dbus,
  innoextract,
  wget,
  fetchurl,
  systemd,
  libgudev,
  fprintd-tod,
  fprintd,
  libusb1,
  gccForLibs,

}:
let
  pname = "synaTudor";
  rev = "0.1";

  the-file = ./meson.build;
in
stdenv.mkDerivation {
  pname = "synaTudor";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "Popax21";
    repo = "synaTudor";
    rev = "31dfdb06107fd1c35c9f9ceae72617e98eccc43a";
    hash = "sha256-/Uh9O2NahVcFg+lk5DkodECOTIyZZwcPs7OKOepagoQ=";
  }; # NURL IS AWESOME

  exe = fetchurl {
    url = "https://download.lenovo.com/pccbbs/mobiles/r19fp02w.exe";
    hash = "sha256-CfBurJRksBhsGxyN7Xlppik3Lh14nPxsi9d3xydbaY8=";
  };

  patches = [
    ./mypatch.patch
    #./add-gio.patch
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    innoextract
  ];
  buildInputs = [
    openssl
    libusb1
    libcap
    libseccomp
    glib
    dbus
    libfprint-tod
    gusb
    gccForLibs.libgcc
  ];
  /*
    unpackPhase = ''
      unzip $src/libfprint-tod-tudor-550a-0.0.9.zip
      cd libfprint-tod-tudor-550a-0.0.9
      ar x libfprint-2-tod-tudor_amd64.deb
      tar xf data.tar.xz
    '';
  */

  configurePhase = ''
    cp ${the-file} libfprint-tod/
    meson setup build
  '';

  buildPhase = ''
    cd ./build
    ninja -d explain
  '';

  installPhase = ''
    mkdir -p "$out/lib/libfprint-2/tod-1/"
    mkdir -p "$out/lib/udev/rules.d/"

    cp usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-tudor-550a-$version.so "$out/lib/libfprint-2/tod-1/"
    cp lib/udev/rules.d/60-libfprint-2-tod1-tudor.rules "$out/lib/udev/rules.d/"
  '';

  #passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = with lib; {
    description = "tudor driver module for libfprint-2-tod Touch OEM Driver (from Lenovo)";
    homepage = "https://support.lenovo.com/us/en/downloads/ds560884-tudor-fingerprint-driver-for-linux-thinkpad-e14-gen-4-e15-gen-4";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ utkarshgupta137 ];
  };
}
