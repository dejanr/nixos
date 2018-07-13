{ config, lib, pkgs, ... }:

{
  imports = [
    ../roles/common.nix
    ../roles/fonts.nix
    ../roles/multimedia.nix
    ../roles/desktop.nix
    ../roles/xmonad.nix
    ../roles/development.nix
    ../roles/services.nix
    ../roles/electronics.nix
    #../roles/games.nix
    #../roles/nas.nix
    #../roles/transmission.nix
    #../roles/plex.nix
    #../roles/virtualization.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "ata_generic" "ehci_pci" "ahci" "mpt3sas" "isci" "xhci_pci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "kvm-intel"
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
      "tun"
      "virtio"
      "coretemp"
    ];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };
    kernelParams = [
      "quiet nomodeset"

      # Use IOMMU
      "intel_iommu=on"
      "i915.preliminary_hw_support=1"
      "vfio_iommu_type1.allow_unsafe_interrupts=1"
      "kvm.allow_unsafe_assigned_interrupts=1"

      # 05:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP106 [GeForce GTX 1060 6GB] [10de:1c03] (rev a1)
      # 05:00.1 Audio device [0403]: NVIDIA Corporation GP106 High Definition Audio Controller [10de:10f1] (rev a1)

      # Assign devices to vfio
      # "vfio-pci.ids=10de:1c03,10de:10f1"

      # Needed by OS X
      "kvm.ignore_msrs=1"

      # Only schedule cpus 0,1
      # "isolcpus=1-3,5-7"
    ];
    blacklistedKernelModules = [
      "nouveau"
    ];
    extraModulePackages = [];
    extraModprobeConfig = ''
    '';

    supportedFilesystems = [ "zfs" ];

    loader = {
      systemd-boot.enable = true;
      generationsDir.enable = false;
      generationsDir.copyKernels = false;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };

    cleanTmpDir = true;
  };

  fileSystems."/" =
    { device = "root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home/dejanr/documents" =
    { device = "storage/documents";
      fsType = "zfs";
    };

  fileSystems."/home/dejanr/downloads" =
    { device = "storage/downloads";
      fsType = "zfs";
    };

  fileSystems."/home/dejanr/movies" =
    { device = "storage/movies";
      fsType = "zfs";
    };

  fileSystems."/home/dejanr/pictures" =
    { device = "storage/pictures";
      fsType = "zfs";
    };

  fileSystems."/home/dejanr/projects" =
    { device = "storage/projects";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/sda1";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking = {
    hostId = "8425e349";
    hostName = "homelab";
  };

  services = {
    unifi.enable = true;

    xserver = {
      videoDrivers = [ "nvidia" ];

      modules = [ pkgs.xf86_input_mtrack ];

      multitouch = {
        enable = false;
        invertScroll = true;
      };

      synaptics = {
        enable = false;
        horizontalScroll = true;
      };

      displayManager = {
        xserverArgs = [ "-dpi 92" ];
      };
    };
  };

  environment = {
    etc."X11/Xresources".text = ''
      Xft.dpi: 92
    '';
  };

  nix.maxJobs = lib.mkDefault 40;

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "performance";
  };
}
