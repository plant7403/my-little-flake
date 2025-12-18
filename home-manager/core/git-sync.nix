{ pkgs, ... }:
{
  services.git-sync = {
    enable = true;
    repositories = {
      my-little-flake = {
        extraPackages = with pkgs; [ git-crypt ];
        #interval = 1;
        path = "/home/egor/my-little-flake";
        uri = "git+ssh://git@git.disroot.org/me/my-little-flake.git";
      };
    };
  };
}
