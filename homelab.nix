{ config, lib, pkgs, ... }:

{
  imports = [
    ./configuration/common.nix
    ./configuration/desktop.nix
    ./configuration/i3.nix
    ./configuration/multimedia.nix
    ./configuration/development.nix
    ./configuration/services.nix
    ./configuration/electronics.nix
    ./configuration/mediaserver.nix
    ./configuration/games.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "ata_generic" "ehci_pci" "ahci" "mpt3sas" "isci" "xhci_pci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
    kernelModules = [
      "kvm-intel"
    ];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };
    kernelParams = [ "quiet nomodeset" ];
    blacklistedKernelModules = [];
    extraModulePackages = [ ];
    extraModprobeConfig = ''
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

  fileSystems."/" = {
    device = "zroot/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  swapDevices = [ ];

  networking = {
    hostId = "8425e349";
    hostName = "homelab";
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      displayManager.xserverArgs = [ "-dpi 92" ];
    };
  };

  environment = {
    etc."X11/Xresources".text = ''
      Xft.dpi: 92
    '';
  };

  nix.maxJobs = lib.mkDefault 40;
  powerManagement.cpuFreqGovernor = "powersave";

  system.stateVersion = "17.09";
}
