{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./configuration/common.nix
      ./configuration/xmonad.nix
    ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.devices = [ "/dev/sda" "/dev/sdb" ];
  };

  hardware.bluetooth.enable = true;

  networking = {
    hostName = "workstation";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };
}
