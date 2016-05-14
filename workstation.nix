{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./configuration/common.nix
      ./configuration/i3.nix
      ./configuration/virtualization.nix
    ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
    blacklistedKernelModules = [ "snd_pcsp" ];
    extraModulePackages = [ ];
    extraModprobeConfig = ''
      options snd slots=snd-hda-intel
    '';

    supportedFilesystems = [ "zfs" ];

    loader.gummiboot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems."/" =
    { device = "tank/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "tank/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/sda1";
      fsType = "vfat";
    };

  networking = {
    hostId = "8e27eca5";
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

  hardware = {
    pulseaudio.enable = true;
  };

  swapDevices = [ ];

  nix.maxJobs = 8;

  system.stateVersion = "16.09";
}
