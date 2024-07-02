{
  inputs,
  pkgs,
  sops-nix,
  ...
}: {
  #imports = [
  #  inputs.sops-nix.homeManagerModules.sops
  #];

  sops = {
    gnupg = {
      home = "~/.gnupg";
      sshKeyPaths = [];
    };
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    #age.keyFile = /home/egor/.config/sops/age/keys.txt;
  };

  home.packages = with pkgs; [
    sops
  ];
}
