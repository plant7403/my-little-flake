{ inputs
, pkgs
, sops-nix
, config
, ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    gnupg = {
      home = "~/.gnupg";
      sshKeyPaths = [];
    };
    #defaultSymlinkPath = "/run/user/1000/secrets";
    #defaultSecretsMountPoint = "/run/user/1000/secrets.d";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    #age.keyFile = /home/egor/.config/sops/age/keys.txt;
  };

  home.packages = with pkgs; [
    sops
  ];
  home.activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    /run/current-system/sw/bin/systemctl start --user sops-nix
  '';
  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
  sops.secrets."users/stellar/yubikey" = {
      sopsFile = ./secrets.yaml;
    }; # REMOVE
}
