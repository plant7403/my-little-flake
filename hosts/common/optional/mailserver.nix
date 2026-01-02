{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-mailserver.nixosModule
  ];
  mailserver = {
    enable = true;
    fqdn = "mail.egor.wtf";
    domains = [ "egor.wtf" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "me@egor.wtf" = {
        hashedPasswordFile = config.sops.secrets."mail/egor.wtf/me".path;
        aliases = [ "postmaster@egor.wtf" ];
      };
      "hello@egor.wtf" = {
        hashedPasswordFile = config.sops.secrets."mail/egor.wtf/me".path;
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "ssl@egor.wtf";

  sops.secrets."mail/egor.wtf/me" = {
    #owner = "nextcloud";
  };
}
