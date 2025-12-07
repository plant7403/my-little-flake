with (import <nixpkgs> { });

haskell.lib.buildStackProject {
  name = "gnome-ext-hanabi";
  src = ./default.nix;
}
