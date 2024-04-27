# TODO - Look into it
{
  config,
  lib,
  ...
}: let
  inherit (lib) filterAttrs mkIf;
  regularSecrets = filterAttrs (n: v: !v.neededForUsers) config.sops.secrets;
in {
  #  imports = [inputs.sops-nix.nixosModules.sops];
  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
  sops.defaultSopsFile = ./../../secrets/example.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/persist/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;
  # This is the actual specification of the secrets.
  #environment.persistence."/persist" = {
  #    directories = ["/var/lib/sops-nix"];
  #};
  systemd.services.sops-hack = {
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = ''
        /run/current-system/activate
      '';
      Type = "oneshot";
      Restart = "on-failure"; # because oneshot
      RestartSec = "10s";
    };
  };
  #systemd.services.decrypt-sops = {
  #  description = "Decrypt sops secrets";
  #  wantedBy = ["multi-user.target"];
  #  after = ["network-online.target"];
  #  requires = ["network-online.target"];
  #  serviceConfig = {
  #    Type = "oneshot";
  #    RemainAfterExit = true;
  #    # in network is not ready
  #    Restart = "on-failure";
  #    RestartSec = "2s";
  #  };
  #  script = config.system.activationScripts.setupSecrets.text;
  #};

  # Ensure non-users-secrets from sops are only initialised *after*
  # impermanence's persistence module has linked files into place, otherwise we
  # likely do not have the decryption key (which is most-frequently the ssh
  # host key).
  config = mkIf (regularSecrets != {} && config.environment.persistence != {}) {
    system.activationScripts.setupSecrets.deps = ["persist-files"];
  };
}
