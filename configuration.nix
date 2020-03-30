# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  posh = global_args: run_args: image: (pkgs.writeScriptBin "posh" ''
      #! ${pkgs.bash}/bin/bash
      source /etc/profile
      tty -s && tty="-t" || quiet="-q"
      test -S "$SSH_AUTH_SOCK" && ssh="-v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -e SSH_AUTH_SOCK"
      ${pkgs.podman}/bin/podman pull $quiet ${image} >/dev/null
      shift
      exec ${pkgs.podman}/bin/podman ${global_args} run --rm -i $tty $ssh -v ~/:/root -w /root --network host ${run_args} ${image} $@
    '')
    .overrideAttrs(attrs: attrs // {
        passthru = {
          shellPath = "/bin/posh";
        };
    });
in {
  imports = [ ./hardware-configuration.nix ./sshonly.nix ./ddns.nix ./sgx.nix ./podman.nix ];
  system.stateVersion = "19.09";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = { "fs.inotify.max_user_watches" = "524288"; };

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
    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIoZP5bZedmrj/lidLkKXhvZwwl9Pj5VxLV22nXhkijt7UJhSUX/rOV4Kg/wmR5ptMjGyE4PPSHmCEzXvQnpyMU= nathaniel@mccallum.life"
      ];
    };
    npmccallum = {
      shell = posh "" "--device /dev/sgx/enclave" "quay.io/enarx/fedora";
      isNormalUser = true;
      subUidRanges = [{ startUid = 100000; count = 10000; }];
      subGidRanges = [{ startGid = 100000; count = 10000; }];
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIoZP5bZedmrj/lidLkKXhvZwwl9Pj5VxLV22nXhkijt7UJhSUX/rOV4Kg/wmR5ptMjGyE4PPSHmCEzXvQnpyMU= nathaniel@mccallum.life"
      ];
    };
    mbestavros = {
      shell = posh "" "--device /dev/sgx/enclave" "quay.io/enarx/fedora";
      isNormalUser = true;
      subUidRanges = [{ startUid = 110000; count = 10000; }];
      subGidRanges = [{ startGid = 110000; count = 10000; }];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsU/LopyQqsuwKZ/I1FKhzXxvRtamvS1pO/XArdM8/pJ2/CErgCxfrudZLR0Am4aqqQ1Luf3F6EVjiLKeQpqoTSc1tQYAXlUI8oqRLyh9j8G765dUzW5/ebMaIpzZGw5DlJKMXR3dM5pwXTSn8KXUmSqzi+mZNlJVaf4usFqkA35AixbuuibtngN3+wz1bAKtZmWy4j0KlA5MZFSTz+M2IWMhJdSXdospCcj7k76VH2PlCjMyH+bfUcbVQT7U6agzTVnk0qG2aptnhnfgV6HpWX8KFo0ajHigpPm7kRmWxk9PUlS3N4hIgu01TndMjDl9HIVIfF4MoRniVwVx7pDe7uaxOUNGVPOS+Pv7B8WD0nDxbOGuekPdTzZzceqEow36yOwzKUe/vgFls2ipVSfJAZfEZiFx07oZ1DLgJ7aibmF+LQygVDWyT7fb4Vrf7A1rDY+b8JoCItuP/ZODN4G8eXtYE4YRY799/+VmtU8xMAHYoMiG2QNz+X6gyyVVaoA1aPB01YRpQjkICqTJY9Wgwx1yw4rRel6pMKFUdeHlHRSaGm1Lq8sx4MXhb9qqAnqxVXO8SFFMHLRkHklZoz1Kl6OBeYHpH0ob+n/seyGmZz8TRBTOS21NnydCAHlemzbOwnoHCHFxGxdJ6Sb5IRQYkx666/7bmZzLsxos74BLDGQ== your_email@example.com"
      ];
    };
    lsturman = {
      shell = posh "" "--device /dev/sgx/enclave" "quay.io/enarx/fedora";
      isNormalUser = true;
      subUidRanges = [{ startUid = 120000; count = 10000; }];
      subGidRanges = [{ startGid = 120000; count = 10000; }];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaSL2QaBqFlZrmfYKFV81+eM+1l5PzQAevLcWkZhpYXHIzZmTazp6AQcpin77Ip4v88GwLnLifuf/xBVNozH7/bRTpj8q1ynJGcpMJrau7DGRj6Afr4b4kzgAZBq6tTXxzXAIekzcCv+n/Ew8DlDpWubR7Nyckt9ak+dNkXXQKOC1lnqU+noatRjfXK4BNn5RsTxXuRvExmSNqLvzGlQIITcKi3M49bqceRVYGV0K0QPbWWNsYhz2VyBH7jYOiTKiu8zBN4p+cpSUdMARsAcWZITeALYMuzIPLLk60exxe1lqRj2uRg9enPro1rk98L/rLM1pjftlRMZtn3L/+VnuxMpNDzQx2pSD2WoL1IOkMDQbwuROke1S8O4KY/9ygYSs2e9Eh4HxogjX+UKCLGlC0jzZcJYlV2X3U0ekCbWf/jPO64b4k9Jb48+xdw2f+dG4AckPG9I2GDH0b3INBGx77gC2IQsb4y3sXqys0vk4Zi4fTLkzW//6Fk8TBT6xVen9VbnsoJi6Gz9OcHIQSioF/sAwg0guBeZx9iWMDc93YjdyveUOlMP9assbL+0HVL5VQodcbJnmXbsNcZ3i/EE0TtzNMruEByTAwppA/jiDWRj/Dm77spXNDE/bQTz+NRWxca3wEePWSDdXFb+x8Ga21qaxKmpNz6z3teFVKI7qoaQ== lsturman@redhat.com"
      ];
    };
    ckuehl = {
      shell = posh "" "--device /dev/kvm" "quay.io/enarx/fedora";
      isNormalUser = true;
      subUidRanges = [{ startUid = 130000; count = 10000; }];
      subGidRanges = [{ startGid = 130000; count = 10000; }];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbwqCwkJqRonnAiY/frDu8uVOOmo112ei24OU88J35jER+uiMaAWKGwPqF6V+Y4zjdT69rrjEfyNSQOwfAhdVFkZOARuBY4i5w0ZzvNd1H8Df4AFQvERMaIpcwQgCj/zf/tdb+zxh9TLd2TPDO0bQ1rhl5hhY7WBiIc1VLRRHJgnWi0gHqPpf+eccn6T71CSaeQDmSJ7ojJru6QXrIKfSVp6Cmm76IpczCfuoRYksvOS8o6utyQANhNw3zjf6l4kiF59Z/16g0XWGo8GrdTJeIXWsjq8YttK0MmCSRHk8p4GZiSgMk5sb7fmXuCD6Hr/IBuqQdtfSECRKfRbHHgmrVMVxB1+QW/N1GLKIxwHrAuYQ6DIWDTQJsGiJBmKM9FpLSJpzu1VG/6oWPcqLYmub71KVtAwfw7HZZ5ww2HKLy6DXjEFwFH5qBNqYJOHgbZXi5CnDeLsOTL1NwgOHV893VP62FvDemRIwR4W0yj6vIdiswGNKTwXTKEC9hdBSTTc9okUrq9mZtUFEk+mTiqnn1OFkbhflB/vk7IhepELv7k6qVdCri9hJ66biqzhNXorPAZg44JSr+LNP1X6GWh8ubFu+ijEudUua/FAr7HoBofC0cptA61N0s5EEBaAVx9yqw925jXovre4SAV1kvB9Vl4xTOiQ5spp+x+UE5QiIs4w== ckuehl@redhat-laptop"
      ];
    };
    bdas = {
      shell = posh "" "--device /dev/kvm" "quay.io/enarx/fedora";
      isNormalUser = true;
      subUidRanges = [{ startUid = 140000; count = 10000; }];
      subGidRanges = [{ startGid = 140000; count = 10000; }];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDo8OxuYPC0uXSv6W5DM0yTnkL4W0xWzzkhWkAU/BvOeLIFFc6JJ5F6PltmxpZcPCySkOYs456hMyTGLQid0v4zSBMX5/E8+djEIiinvd6hqY3JuFEqAsg1SXusL+IrI1qlcTjy9MJxWPntTZGQ4Kq1HzEpTBaIdRUaPdd6/6SsYWJKY3lwEt/JUOCx618qxhWcU2ms8xDu4zxcu4AiyQM46lqTGOSO5gWu+5g8CV+UNiJWiTGrRxXuekgwLCvkCuYoBcQs4Ojft1rFf3MaBhSdytphmQ6x4iE5JPnr01JTGbB6wneHmllS71EMJ7teizAF+/jPw8MCV2FGHOkPRG0FFBBiMODXC7StmoSEM9Y+tv1Lz9KavCElfn623X8CbxCSUalj/88I9rWocXQqBmxXU7mEGEGDGB0ZXZX7S9yZ3r8nzY4dITnXziw6IooaQURY6D7Oi94Znsggq3SwdzhhjSTUfSRppsLPqcUM5rD+0PekGC9UR+GSdjCslL6xqwE= bdas@localhost.localdomain"
      ];
    };
  };
}

