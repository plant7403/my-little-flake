{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #neovim
    #vimPlugins.LazyVim
    nerd-fonts.monoid
    lazygit
    tree-sitter
    #vimPlugins.nvim-treesitter
    fzf
    ripgrep
    fd
  ];
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
  };
  stylix = {
    enable = true;
    autoEnable = true;
    targets = {
      ghostty.enable = true;
    };
  };
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      yankring
      vim-nix
      {
        plugin = vim-startify;
        config = "let g:startify_change_to_vcs_root = 0";
      }
      nvim-treesitter
      LazyVim
    ];
  };
}
