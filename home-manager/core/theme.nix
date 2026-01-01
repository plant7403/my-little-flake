{
  pkgs,
  lib,
  ...
}:
let

  inputImage = pkgs.fetchurl {
    url = "https://4kwallpapers.com/images/wallpapers/chainsaw-man-the-3840x2160-22996.jpg";
    sha256 = "sha256-AbHCVUrbtK+jhVonRscYBU5x1+FDHLp3/ffY87ZD4ck=";
  };
  brightness = "0";
  contrast = "0";
  fillColor = "black";
in
{
  stylix = {
    #enable = true;
    enableReleaseChecks = true;
    #stylix.image = /run/current-system/sw/share/backgrounds/gnome/vnc-d.png;
    image = lib.mkForce (
      pkgs.runCommand "dimmed-background.png" { } ''
        ${lib.getExe' pkgs.imagemagick "convert"} "${inputImage}" -brightness-contrast ${brightness},${contrast} -fill ${fillColor} $out
      ''
    );
    targets = {
      gtk = {
        flatpakSupport.enable = true;
        extraCss = ''
          window {
            --wm-border-width: 3px;
            --wm-border-color: #6272a4;
            --wm-border-radius: 12px;
          }

          window.maximized {
            border: 3px solid #6272a4;
            border-radius: 12px;
          }

          window:not(.maximized) {
            border: none;
          }

          window.csd {
            margin: 0px;
            border-radius: 12px;
            border: 3px solid #6272a4;
          }

          window.csd.popup,
          window.csd.dialog.message {
            border-radius: 12px;
            border: 4px solid #6272a4;
          }

          window.solid-csd {
            margin: 0;
            padding: 4px;
            border-radius: 12px;
            border: 4px solid #6272a4;
          }

          window.popup,
          window.ssd {
            border-radius: 12px;
            border: 4px solid #6272a4;
          }
        '';
      };
    };
    base16Scheme = {
      slug = "metheme";
      scheme = "Theme by me";
      author = "me";
      base00 = "241b26";
      base01 = "2f2a3f";
      base02 = "46354a";
      base03 = "89787f";
      base04 = "ffffff";
      base05 = "eed5d9";
      base06 = "d9c2c6";
      base07 = "e4ccd0";
      base08 = "877bb6";
      base09 = "de5b44";
      base0A = "a84a73";
      base0B = "c965bf";
      base0C = "9c5fce";
      base0D = "6a9eb5";
      base0E = "78a38f";
      base0F = "9e5769";
    };
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      accent-color = "teal";
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:nocaps" ];
    };
  };

  /*
    gtk = {
      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
  */

  #qt.enable = true;
  #qt.platformTheme = lib.mkForce "qtct";
  /*
    qt.style.name = "kvantum";

    home.packages = with pkgs; [

      (catppuccin-kvantum.override {
        accent = "Mauve";
        variant = "Mocha";
      })
    ];

    xdg.configFile."Kvantum/kvantum.kvconfig".source =
      (pkgs.formats.ini { }).generate "kvantum.kvconfig"
        {
          General.Theme = "Catppuccin-Mocha-Mauve";
        };
  */
}
