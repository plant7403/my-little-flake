{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nvim-neotest/neotest";
  maintainers = [ lib.maintainers.user ];
  url = "https://github.com/nvim-neotest/neotest/tree/52fca6717ef972113ddd6ca223e30ad0abb2800c";
  # description = "An example Neovim plugin";
  /*
    settingsOptions = {
      option1 = lib.mkOption {
        type = lib.types.str;
        default = "default-value";
        description = "An example option";
      };
    };
  */
}
