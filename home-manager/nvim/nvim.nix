{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    #inputs.kickstart-nixvim.homeManagerModules.default

  ];
  home.packages = with pkgs; [
    # formatters

    lua
    # linters
    deadnix
    nixpkgs-fmt
    stylua
    statix

    tree-sitter

    nerd-fonts.monoid
    lazygit

    #vimPlugins.nvim-treesitter
    fzf
    ripgrep
    fd
    luarocks
  ];

  programs.nixvim = {
    imports = [
      #./keymaps
      #./plugins
    ];
    enable = true;
    globals.mapleader = " ";
    defaultEditor = true;
    #imports = [ inputs.Neve.nixvimModule ];
    # luaLoader.enable = true;
    nixpkgs.config.allowUnfree = true;
    extraPlugins =
      with pkgs.vimPlugins;
      [
        #bamboo-nvim
        null-ls-nvim
        nvim-nio
        /*
          #opencode-nvim
             oxocarbon-nvim
             snacks-nvim
             zellij-nvim
             nvim-lspconfig

             vim-nix
             gruvbox
             catppuccin-nvim
        */
        which-key-nvim
        nvim-treesitter
      ]
      ++ [
        pkgs.lua51Packages.neotest
        pkgs.lua51Packages.lua
      ];
    #imports = [ ./nvim-plugins/neotest-pin.nix ];
    plugins = {
      /*
        neotest = {
          enable = true;
          package = pkgs.lua51Packages.neotest;
          settings = {
            output = {
              enabled = true;
              open_on_run = true;
            };
            output_panel = {
              enabled = true;
              open = "botright split | resize 15";
            };
            quickfix = {
              enabled = false;
              open = true;
            };
            discovery.enabled = true;
          };
          adapters = {
            plenary.enable = true;
            python = {
              enable = true;

              settings = {
                args = [
                  "--log-level"
                  "DEBUG"
                ];
              };
            };
          };
        };
      */
    };
    plugins.which-key.enable = true;
    plugins.telescope.enable = true;
    #plugins.statuscol.enable = true;
    #plugins.nvim-autopairs.enable = true;
    plugins.dashboard.enable = true;
    plugins.none-ls = {
      enable = true;
    };
    #plugins.indent-blankline.enable = true;
    #plugins.mini-icons.enable = true;
    #plugins.lzn-auto-require.enable = true;
    plugins.lazygit.enable = true;
    plugins.lspconfig.enable = true;
    plugins.neo-tree.enable = true;
    plugins.blink-cmp.enable = true;
    plugins.nvim-treesitter.enable = true;
    plugins.oil.enable = true;

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
    plugins.web-devicons.enable = true;
    plugins.fzf-lua.enable = true;
    plugins.direnv.enable = true;
    plugins.dap.enable = true;
    #plugins.dap-ui.enable = true;
    #plugins.dap-view.enable = true;
    #plugins.dap-virtual-text.enable = true;
    #plugins.dap-rr.enable = true;
    #plugins.dap-lldb.enable = true;
    #plugins.compiler.enable = true;
    #plugins.comment.enable = true;
    plugins.clangd-extensions.enable = true;
    /*
      plugins.lsp = {
        enable = true;
        inlayHints = true;
        servers.clangd.enable = true;
      };
    */
    #plugins.mini-icons.mockDevIcons = true;
    plugins.treesitter = {
      enable = true;
      nixGrammars = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        json
        lua
        make
        markdown
        nix
        regex
        toml
        vim
        vimdoc
        xml
        yaml
      ];
    };

    dependencies = {
      direnv.enable = true;

    };

    /*
      performance = {
         byteCompileLua = {
           enable = true;
           nvimRuntime = true;
           plugins = true;
         };
       };
    */

  };
  stylix = {
    enable = true;
    autoEnable = true;
    targets = {
      #nvim.enable = true;
      nixvim.enable = false;
    };
  };
}
