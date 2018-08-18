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
    ../roles/games.nix
    ../roles/nas.nix
    ../roles/transmission.nix
    ../roles/plex.nix
    ../roles/virtualization.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "ata_generic" "ehci_pci" "ahci" "mpt3sas" "isci" "xhci_pci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
    initrd.kernelModules = [ "vfio_pci" ];
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "kvm"
      "kvm_intel"
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio_virqfd"
      "tun"
      "virtio"
      "coretemp"
    ];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };
    kernelParams = [
      "quiet nomodeset"
      "usbhid.quirks=0x046d:0xc07e:0x00000400"
      "usbhid.quirks=0x16c0:0x047c:0x00000400"

      "vfio-pci.ids=10de:1c03,10de:10f1"

      # Use IOMMU
      "intel_iommu=on"
      "i915.preliminary_hw_support=1"
      "i915.enable_hd_vgaarb=1"
      "vfio_iommu_type1.allow_unsafe_interrupts=1"

      "kvm.allow_unsafe_assigned_interrupts=1"

      # Needed by OS X
      "kvm.ignore_msrs=1"
      "kvm_intel.nested=1"
      "kvm_intel.emulate_invalid_guest_state=0"

      # Only schedule cpus 0,1
      # "isolcpus=1-3,5-7"

      "hugepagesz=1GB"
    ];
    blacklistedKernelModules = [
      "nouveau" "nvidia"
    ];
    extraModulePackages = [];
    extraModprobeConfig = ''
      # 41:00.0 VGA compatible controller: NVIDIA Corporation GP106 [GeForce GTX 1060 6GB] (rev a1)
      # 41:00.1 Audio device: NVIDIA Corporation GP106 High Definition Audio Controller (rev a1)

      # Assign devices to vfio
      options vfio-pci ids=10de:1c03,10de:10f1
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
        xserverArgs = [ "-dpi 109" ];
      };
    };

    journald.extraConfig = ''
      Compress=yes
      SystemMaxUse=1024M
      SystemMaxFileSize=8M
    '';
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
