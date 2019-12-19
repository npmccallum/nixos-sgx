{ config, pkgs, ... }:

{
  services.udev.extraRules = ''SUBSYSTEM=="sgx", MODE="0666"'';

  boot.kernelPackages = let
      linux_sgx_pkg = { stdenv, fetchurl, buildLinux, ... } @ args:

        with stdenv.lib;

        buildLinux (args // rec {
          version = "5.4.0-rc3";
          modDirVersion = "5.4.0-rc3";

          src = fetchurl {
            url = "https://github.com/jsakkine-intel/linux-sgx/archive/v24.tar.gz";
            sha256 = "17aacpw8jd9v29knwkbjcc4pl3nhi45jn3w9sbcc2199r688yyda";
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
