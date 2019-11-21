# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  system.stateVersion = "19.09";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.wireless.enable = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlo2.useDHCP = true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "US/Eastern";

  environment.systemPackages = with pkgs; [ wget vim git tmux cargo rustc rustfmt ];

  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no"; 

  security.sudo.enable = true;
  security.pam.enableSSHAgentAuth = true;
  security.pam.services.sudo.sshAgentAuth = true;
  security.pam.services.login.makeHomeDir = true;
  security.pam.services.sshd.makeHomeDir = true;

  users.mutableUsers = false;
  users.users.npmccallum = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIoZP5bZedmrj/lidLkKXhvZwwl9Pj5VxLV22nXhkijt7UJhSUX/rOV4Kg/wmR5ptMjGyE4PPSHmCEzXvQnpyMU= nathaniel@mccallum.life"
    ];
  };

  boot.kernelPackages = let
      linux_sgx_pkg = { stdenv, fetchurl, buildLinux, ... } @ args:

        with stdenv.lib;

        buildLinux (args // rec {
          version = "5.4.0-rc3";
          modDirVersion = "5.4.0-rc3";

          src = fetchurl {
            url = "https://github.com/jsakkine-intel/linux-sgx/archive/v23.tar.gz";
            sha256 = "11rwlwv7s071ia889dk1dgrxprxiwgi7djhg47vi56dj81jgib20";
          };
          kernelPatches = [];

          extraConfig = ''
            INTEL_SGX y
          '';

          extraMeta.branch = "5.4";
        } // (args.argsOverride or {}));
      linux_sgx = pkgs.callPackage linux_sgx_pkg{};
    in
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_sgx);
}

