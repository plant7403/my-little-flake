{...}: {
  services.borgbackup.jobs = {
    libraries = {
      #user = "root";
      paths = builtins.map (name: "${name}") [
        "/persist"
        "/home"
        "/root"
      ];
      exclude = [
        "/persist/var/lib/monero"
      ];
      repo = "/hdd/Backup";
      prune.keep = {
        daily = 7;
        weekly = 3;
        monthly = -1;
        yearly = -1;
      };
      startAt = "06:00";
      persistentTimer = true;
      encryption.mode = "none";
    };
    #tmp = {
    #  #user = "root";
    #  paths = builtins.map (name: "/home/michal_atlas/${name}") [
    #    "Downloads"
    #    "tmp"
    #  ];
    #  postCreate = ''
    #    ${pkgs.coreutils}/bin/rm -r /home/michal_atlas/{tmp,Downloads}
    #    ${pkgs.coreutils}/bin/mkdir /home/michal_atlas/{tmp,Downloads}
    #  '';
    #  repo = "/home/michal_atlas/borg/tmps";
    #  prune.keep = { daily = -1; };
    #  startAt = "06:00";
    #  persistentTimer = true;
    #  encryption.mode = "none";
    #};
  };
}
