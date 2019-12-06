{ config, pkgs, ... }:

{
  services.udev.extraRules = ''SUBSYSTEM=="sgx", MODE="0666"'';
  boot.kernelPackages = pkgs.steveej_pkgs.linuxPackages_sgx_latest;
}


