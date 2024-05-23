{configs, ...}: {
  services.openssh.hostKeys = [
    {
      bits = 4096;
      path = config.sops.secrets."system/hostkeys/luna/rsa`".path;
      type = "rsa";
    }
    {
      path = config.sops.secrets."system/hostkeys/luna/ed25519".path;
      type = "ed25519";
    }
  ];
  sops.secrets."system/hostkeys/luna/rsa" = {};
  sops.secrets."system/hostkeys/luna/ed25519" = {};
}
