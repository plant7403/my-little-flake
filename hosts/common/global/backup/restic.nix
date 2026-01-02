{
  config,
  pkgs,
  ...
}:
{
  sops.secrets = {
    "system/restic/encryption" = { };
    #    "system/restic/b2-id" = {};
    #    "system/restic/b2-key" = {};
    "system/restic/s3.env" = { };
  };
  environment.systemPackages = [ pkgs.restic ];

  services.restic.backups.system = {
    initialize = true;
    # since this uses an `agenix` secret that's only readable to the
    # root user, we need to run this script as root. If your
    # environment is configured differently, you may be able to do:
    #
    # user = "myuser
    #
    passwordFile = config.sops.secrets."system/restic/encryption".path;
    environmentFile = config.sops.secrets."system/restic/s3.env".path;
    # what to backup.
    paths = [
      "/persist"
      "/home/egor"
    ];
    exclude = [
      "/persist/data/Media"
      "/persist/var/lib/monero"
    ];
    # the name of your repository.
    repository = "s3:https://s3.eu-central-003.backblazeb2.com/immortal-server-backup";
    timerConfig = {
      # backup every 1d
      OnUnitActiveSec = "1d";
    };

    # keep 7 daily, 5 weekly, and 10 annual backups
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-yearly 10"
    ];
  };

  # Instead of doing this, you may alternatively hijack the
  # `awsS3Credentials` argument to pass along these environment
  # vars.
  #
  # If you specified a user above, you need to change it to:
  # systemd.services.user.restic-backups-myaccount = { ... }
  #
  #  systemd.services.restic-backups-myaccount = {
  #    environment = {
  #      B2_ACCOUNT_ID = config.sops.secrets."system/restic/b2-id".path;
  #      B2_ACCOUNT_KEY = config.sops.secrets."system/restic/b2-key".path;
  #    };
  #  };
}
