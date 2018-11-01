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
    #../roles/nas.nix
    #../roles/transmission.nix
    #../roles/plex.nix
    #../roles/virtualization.nix
  ];

  boot = {
  initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "kvm-intel"
      "tun"
      "coretemp"
    ];
    kernel.sysctl = {
    };
    kernelParams = [
    ];
    blacklistedKernelModules = [
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
    { device = "root/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "root/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6FB1-C165";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking = {
    hostId = "8425e349";
    hostName = "workstation";
  };

  services = {
    unifi.enable = true;

    xserver = {
      videoDrivers = [ "intel" ];

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
      Xft.dpi: 109
    '';
  };


  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    s3tcSupport = true;
    extraPackages = [
      pkgs.vaapiIntel
    ];
  };

  nix.maxJobs = lib.mkDefault 8;
}
