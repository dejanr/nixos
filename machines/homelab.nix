{ config, lib, pkgs, ... }:

{
  imports = [
    ../roles/common.nix
    ../roles/fonts.nix
    ../roles/multimedia.nix
    ../roles/desktop.nix
    ../roles/i3.nix
    ../roles/development.nix
    ../roles/services.nix
    ../roles/electronics.nix
    ../roles/games.nix
    #../roles/nas.nix
    #../roles/transmission.nix
    #../roles/plex.nix
    ../roles/virtualization.nix
    ../roles/autolock.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ "vfio_pci" "fbcon" ];
    kernelModules = [
      "kvm"
      "kvm_intel"
      "kvm-intel"
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio_virqfd"
      "tun"
      "virtio"
      "coretemp"
      "nct6775"
    ];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };
    kernelParams = [
      "quiet nomodeset"

      #"vfio-pci.ids=10de:1c03,10de:10f1"

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
      #options vfio-pci ids=10de:1c03,10de:10f1
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
    { device = "zpool/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "zpool/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/FECA-3A1C";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking = {
    hostId = "8425e349";
    hostName = "homelab";
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [ pkgs.vaapiIntel pkgs.libvdpau-va-gl pkgs.vaapiVdpau ];
    };
    pulseaudio.support32Bit = true;
  };

  services = {
    unifi.enable = true;

    octoprint = {
      enable = true;
    };

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      displayManager = {
        xserverArgs = [ "-dpi 109" ];
      };
    };
  };

  users.users.octoprint.extraGroups = [ "dialout" ];

  environment = {
    etc."X11/Xresources".text = ''
      Xft.dpi: 109
    '';
  };

  nix.maxJobs = lib.mkDefault 8;
}
