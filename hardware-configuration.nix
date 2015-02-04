{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_hcd" "ahci" "usb_storage" "usbhid" ];
    };

    kernelModules = [ "kvm-intel" "wl" ];

    extraModulePackages = [
      config.boot.kernelPackages.broadcom_sta
      config.boot.kernelPackages.v4l2loopback
    ];
  };

  hardware = {
    pulseaudio.enable = true;
  };

  fileSystems."/" =
    { device = "/dev/sda5";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/sda1";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/sda4";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/sda6"; }
    ];

  nix.maxJobs = 8;
}
