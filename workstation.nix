{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./configuration/common.nix
      ./configuration/desktop.nix
      ./configuration/i3.nix
      ./configuration/multimedia.nix
      ./configuration/development.nix
      ./configuration/virtualization.nix
      ./configuration/services.nix
    ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [
      "kvm-intel"
    ];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };
    blacklistedKernelModules = [ "snd_pcsp" ];
    extraModulePackages = [ ];
    extraModprobeConfig = ''
      options snd slots=snd-hda-intel
    '';

    supportedFilesystems = [ "zfs" ];

    loader = {
      systemd-boot.enable = true;
      generationsDir.enable = false;
      generationsDir.copyKernels = false;
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };

    cleanTmpDir = true;
  };

  fileSystems."/" =
    { device = "zpool/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A894-E82E";
      fsType = "vfat";
    };


  networking = {
    hostId = "8425e349";
    hostName = "workstation";
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      displayManager.xserverArgs = [ "-dpi 92" ];
    };

    acpid = {
      acEventCommands = ''
        /run/current-system/sw/bin/cpupower frequency-set -u 4.30GHz
        tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor <<< performance
      '';
    };
  };

  environment = {
    etc."X11/Xresources".text = ''
      Xft.dpi: 92
    '';
  };

  swapDevices = [ ];

  nix.maxJobs = 8;

  system.stateVersion = "16.09";
}
