final: prev: {
  gtksourceview = prev.gtksourceview.overrideAttrs (oldAttrs: {
    doChecks = false;
  });
}

/*
    mesonCheckFlags = oldAttrs.mesonCheckFlags or [ ] ++ [
      "--timeout-multiplier"
      "0"
    ];
*/
