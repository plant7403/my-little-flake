final: prev: {
  gtksourceview = prev.gtksourceview.overrideAttrs (oldAttrs: {
    doCheck = false;
  });
}

/*
    mesonCheckFlags = oldAttrs.mesonCheckFlags or [ ] ++ [
      "--timeout-multiplier"
      "0"
    ];
*/
