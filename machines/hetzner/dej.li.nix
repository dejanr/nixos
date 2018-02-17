{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ../../roles/common.nix
    ../../roles/znc.nix
  ];

  boot = {
    cleanTmpDir = true;
    kernelParams = ["boot.shell_on_fail"];
    kernelModules = [ ];
    extraModulePackages = [ ];

    loader.grub.device = "/dev/sda";
    loader.grub.storePath = "/nixos/nix/store";

    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" ];
    initrd.supportedFilesystems = [ "ext4" ];
    initrd.postDeviceCommands = ''
      mkdir -p /mnt-root/old-root ;
      mount -t ext4 /dev/sda1 /mnt-root/old-root ;
    '';

    loader.grub.enable = true;
    loader.grub.version = 2;
  };

  fileSystems = {
    "/" = {
      device = "/old-root/nixos";
      fsType = "none";
      options = [ "bind" ];
    };

    "/old-root" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
  };

  swapDevices = [ ];

  networking = {
    hostName = "dej.li";
    extraHosts = "127.0.0.1 weechat.dej.li";
  };

  services = {
    fail2ban = {
      enable = true;
      jails = {
        ssh-iptables = ''
          enabled  = true
        '';
      };
    };

    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    ntp.enable = false;
    chrony.enable = true;
  };

  security.acme.certs = {
    "dej.li" = {
      webroot = "/var/www/challenges";
      email = "dejan@ranisavljevic.com";
      postRun = "systemctl restart nginx.service";
    };
  };

  services.nginx = {
    enable = true;

    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "dej.li" = {
        enableACME = false;
        addSSL = true;
        sslCertificate = "${config.security.acme.directory}/dej.li/fullchain.pem";
        sslCertificateKey = "${config.security.acme.directory}/dej.li/key.pem";

        locations."/" = {
          root = "/var/www/dej.li";
        };
      };
    };
  };

  nix.maxJobs = lib.mkDefault 1;

  system.stateVersion = "18.03";
}
