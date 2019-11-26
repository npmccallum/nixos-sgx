{ config, pkgs, ... }:

{
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";

  users.mutableUsers = false;
  security.sudo.enable = true;
  security.pam.enableSSHAgentAuth = true;
  security.pam.services.sshd.makeHomeDir = true;
  security.pam.services.sudo.sshAgentAuth = true;
  security.pam.services.login.makeHomeDir = true;
}
