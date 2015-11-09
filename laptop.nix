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

    loader.gummiboot.enable = true;
    loader.gummiboot.timeout = 3;
    loader.efi.canTouchEfiVariables = true;

    cleanTmpDir = true;
  };

  networking = {
    hostName = "laptop";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    wireless.enable = true;
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      vaapiDrivers = [ pkgs.vaapiIntel ];
    };
  };
}
