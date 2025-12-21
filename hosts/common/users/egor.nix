{
  pkgs,
  config,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  sops.secrets."users/egor/password".neededForUsers = true;

  users.mutableUsers = false;
  users.users.egor = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "networkmanager"
      "video"
      "wheel"
    ]
    ++ ifTheyExist [
      "deluge"
      "docker"
      "git"
      "i2c"
      "libvirtd"
      "media"
      "minecraft"
      "network"
      "podman"
      "sync"
      "syncthing"
      "wireshark"
      "vboxusers"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4OqADgjR4tD/2BFBTfhoi8AchffLyayrr0X5FSKC00ONzNpYeynuw9+bVbZ5a+O1EI3PPyCXKlmC4U3ZGl/jJWauhyXvT0068LC+hVwJfBwrHNbaq9b1Urgz2Mcv2tX9jbpi0hnxHwCQDTNtXptgxDvSLdz86gc6cBg48Y0cntSeNbHbvWFrcZ0iXUJYMpSVHNKPyR25r7SeNtXFvXzPTjPq/+wGsfnhXqbNDwec41zMsc4TBxHVKELFa1AaQF4QQ2SPQsWLSJ151EkybM4OfBxLulgqCzBYkHfjlqWuQqCwN9DOgFimoFLWJT9f8PUOHsu8q0ryTx7viyiFXK51enMGvthP4uRLWn6WdDb7zhe48HGbkWkVXETx78u5bL7hyIlMu9L3AB8gWKI7BYD+FrUyZkasK/e+JO0ECoil4c6jasqInvLVcyQY0loVyppL89CGTZZfTreZLv4Tt6rFuF9sBQ/FqDuA2L2wRgPZKRj1HiO3pppiAKuu5EG2Faotoi49WqM+RJD6O1RG7jWjCYKHB8TfiqrObJt9YRjYBctbWlNzZQs6oC1hKsLkfx1fjSA8PLDevPvK5jPgU6cUEFK22GouVxbdp8ZicTsi7AK6xGxJ2uENPAMFIuh6tqU6u9nI7mceK0vv343Y3pvvc0MawH/nS4+kIG57lL8hnNQ== cardno:19_271_673"
    ];
    hashedPasswordFile = config.sops.secrets."users/egor/password".path;
  };

  services.geoclue2.enable = true;

  programs.zsh.enable = true;
}
