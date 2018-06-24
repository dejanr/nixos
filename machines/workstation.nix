{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../roles/common.nix
      ../roles/desktop.nix
      ../roles/i3.nix
      ../roles/multimedia.nix
      ../roles/development.nix
      ../roles/services.nix
    ];

  boot = {
    initrd.availableKernelModules = [ "ata_generic" "ehci_pci" "ahci" "mpt3sas" "xhci_pci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" ];
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
    { device = "main/ROOT/nixos";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/01A9-F338";
      fsType = "vfat";
    };

  swapDevices = [ ];

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

  nix.maxJobs = lib.mkDefault 40;

  system.nixos.stateVersion = "18.03";
}
