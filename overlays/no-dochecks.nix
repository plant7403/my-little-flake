_final: prev: {
  gtksourceview = prev.gtksourceview.overrideAttrs (_oldAttrs: {
    doCheck = false;
  });
}

/*
    mesonCheckFlags = oldAttrs.mesonCheckFlags or [ ] ++ [
      "--timeout-multiplier"
      "0"
    ];
*/
