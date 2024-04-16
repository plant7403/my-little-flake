{
  services.openssh = {
    enable = true;
    ports = [22 2200 3370];
    settings = {
      PasswordAuthentication = true;
      #allowSFTP = false; # Don't set this if you need sftp
      challengeResponseAuthentication = false;
    };
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding yes
      AllowStreamLocalForwarding yes
      AuthenticationMethods publickey
    '';
  };
  networking.firewall = {
    allowedTCPPorts = [22 2200 3370];
  };
}
