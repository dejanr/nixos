{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./configuration/common.nix
    ];

  boot = {
    initrd.availableKernelModules = [ "xhci_hcd" "ahci" "usb_storage" "usbhid" ];
    kernelModules = [ "kvm-intel" "wl" ];

    extraModulePackages = [
      config.boot.kernelPackages.broadcom_sta
      config.boot.kernelPackages.v4l2loopback
    ];

    extraModprobeConfig = ''
      options libata.force=noncq
      options resume=/dev/sda5
      options snd_hda_intel index=0 model=intel-mac-auto id=PCH
      options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
      options snd_hda_intel model=mbp101
      options hid_apple fnmode=2
    '';

    loader = {
      gummiboot.enable = true;
      gummiboot.timeout = 2;
      generationsDir.enable = false;
      generationsDir.copyKernels = false;
      efi.canTouchEfiVariables = true;
    };

    cleanTmpDir = true;
  };

  networking = {
    hostName = "laptop";
    hostId = "8425e349";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    wireless.enable = true;
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      vaapiDrivers = [ pkgs.vaapiIntel ];
    };
  };

  fileSystems."/" =
    { device = "tank/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/sda4";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = 4;
}
