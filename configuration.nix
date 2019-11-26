# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./sshonly.nix ./ddns.nix ./sgx.nix ./podman.nix ];
  system.stateVersion = "19.09";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.wireless.enable = false;
  networking.interfaces.eno1.useDHCP = true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "US/Eastern";

  environment.systemPackages = with pkgs; [ wget vim git tmux ];

  programs.bash.enableCompletion = true;

  users.users = {
    npmccallum = {
      isNormalUser = true;
      extraGroups = [ "wheel" "sgx" ];
      subUidRanges = [{ startUid = 100000; count = 10000; }];
      subGidRanges = [{ startGid = 100000; count = 10000; }];
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIoZP5bZedmrj/lidLkKXhvZwwl9Pj5VxLV22nXhkijt7UJhSUX/rOV4Kg/wmR5ptMjGyE4PPSHmCEzXvQnpyMU= nathaniel@mccallum.life"
      ];
    };
    mbestavros = {
      isNormalUser = true;
      extraGroups = [ "sgx" ];
      subUidRanges = [{ startUid = 110000; count = 10000; }];
      subGidRanges = [{ startGid = 110000; count = 10000; }];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsU/LopyQqsuwKZ/I1FKhzXxvRtamvS1pO/XArdM8/pJ2/CErgCxfrudZLR0Am4aqqQ1Luf3F6EVjiLKeQpqoTSc1tQYAXlUI8oqRLyh9j8G765dUzW5/ebMaIpzZGw5DlJKMXR3dM5pwXTSn8KXUmSqzi+mZNlJVaf4usFqkA35AixbuuibtngN3+wz1bAKtZmWy4j0KlA5MZFSTz+M2IWMhJdSXdospCcj7k76VH2PlCjMyH+bfUcbVQT7U6agzTVnk0qG2aptnhnfgV6HpWX8KFo0ajHigpPm7kRmWxk9PUlS3N4hIgu01TndMjDl9HIVIfF4MoRniVwVx7pDe7uaxOUNGVPOS+Pv7B8WD0nDxbOGuekPdTzZzceqEow36yOwzKUe/vgFls2ipVSfJAZfEZiFx07oZ1DLgJ7aibmF+LQygVDWyT7fb4Vrf7A1rDY+b8JoCItuP/ZODN4G8eXtYE4YRY799/+VmtU8xMAHYoMiG2QNz+X6gyyVVaoA1aPB01YRpQjkICqTJY9Wgwx1yw4rRel6pMKFUdeHlHRSaGm1Lq8sx4MXhb9qqAnqxVXO8SFFMHLRkHklZoz1Kl6OBeYHpH0ob+n/seyGmZz8TRBTOS21NnydCAHlemzbOwnoHCHFxGxdJ6Sb5IRQYkx666/7bmZzLsxos74BLDGQ== your_email@example.com"
      ];
    };
    lsturman = {
      isNormalUser = true;
      extraGroups = [ "sgx" ];
      subUidRanges = [{ startUid = 120000; count = 10000; }];
      subGidRanges = [{ startGid = 120000; count = 10000; }];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaSL2QaBqFlZrmfYKFV81+eM+1l5PzQAevLcWkZhpYXHIzZmTazp6AQcpin77Ip4v88GwLnLifuf/xBVNozH7/bRTpj8q1ynJGcpMJrau7DGRj6Afr4b4kzgAZBq6tTXxzXAIekzcCv+n/Ew8DlDpWubR7Nyckt9ak+dNkXXQKOC1lnqU+noatRjfXK4BNn5RsTxXuRvExmSNqLvzGlQIITcKi3M49bqceRVYGV0K0QPbWWNsYhz2VyBH7jYOiTKiu8zBN4p+cpSUdMARsAcWZITeALYMuzIPLLk60exxe1lqRj2uRg9enPro1rk98L/rLM1pjftlRMZtn3L/+VnuxMpNDzQx2pSD2WoL1IOkMDQbwuROke1S8O4KY/9ygYSs2e9Eh4HxogjX+UKCLGlC0jzZcJYlV2X3U0ekCbWf/jPO64b4k9Jb48+xdw2f+dG4AckPG9I2GDH0b3INBGx77gC2IQsb4y3sXqys0vk4Zi4fTLkzW//6Fk8TBT6xVen9VbnsoJi6Gz9OcHIQSioF/sAwg0guBeZx9iWMDc93YjdyveUOlMP9assbL+0HVL5VQodcbJnmXbsNcZ3i/EE0TtzNMruEByTAwppA/jiDWRj/Dm77spXNDE/bQTz+NRWxca3wEePWSDdXFb+x8Ga21qaxKmpNz6z3teFVKI7qoaQ== lsturman@redhat.com"
      ];
    };
  };
}

