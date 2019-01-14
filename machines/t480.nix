{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../roles/common.nix
      ../roles/desktop.nix
      ../roles/i3.nix
      ../roles/autolock.nix
      ../roles/multimedia.nix
      ../roles/development.nix
      ../roles/services.nix
      ../roles/fonts.nix
   ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      luks.devices.decrypted-hdd = {
        device = "/dev/disk/by-id/nvme-WDC_PC_SN720_SDAQNTW-512G-1001_184791804261-part2";
        keyFile = "/keyfile.bin";
      };
    };

    kernelModules = [ "kvm-intel" ];

    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };

    supportedFilesystems = [ "zfs" ];
    cleanTmpDir = true;

    loader = {
      efi.efiSysMountPoint = "/efi";

      grub = {
  	device = "nodev";
  	efiSupport = true;
  	extraInitrd = "/boot/initrd.keys.gz";
  	enableCryptodisk = true;
  	zfsSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };

  fileSystems."/" =
    { device = "zroot/root";
      fsType = "zfs";
    };

  fileSystems."/efi" =
    { device = "/dev/disk/by-id/nvme-WDC_PC_SN720_SDAQNTW-512G-1001_184791804261-part1";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking = {
    hostName = "theory";
    hostId = "7392bf5d";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  services = {
    xserver = {
      enable = true;
      enableTCP = false;
      modules = [ pkgs.xf86_input_mtrack ];
      videoDrivers = [ "intel" ];
    };
  };

  environment = {
    etc."X11/Xresources".text = ''
      Xft.dpi: 190
    '';
    variables.QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    variables.GDK_SCALE = "2";
    variables.GDK_DPI_SCALE = "0.5";
  };

  programs.light.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";

  nix.maxJobs = lib.mkDefault 8;

  system.stateVersion = "18.09";
}

