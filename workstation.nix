{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./configuration/common.nix
      ./configuration/xmonad.nix
      ./configuration/virtualization.nix
    ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" ];
    kernelModules = [ "kvm-intel" ];
    blacklistedKernelModules = [ "snd_pcsp" ];
    extraModulePackages = [ ];
    extraModprobeConfig = ''
      options snd slots=snd-hda-intel
    '';

    supportedFilesystems = [ "zfs" ];
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.devices = [ "/dev/sdd" ];
  };

  fileSystems = [
    {
      mountPoint = "/";
      device = "rpool/root/nixos";
      fsType = "zfs";
    }
    {
      mountPoint = "/boot";
      device = "/dev/sdd1";
      fsType = "ext3";
    }
  ];

  networking = {
    hostId = "8e27eca5";
    hostName = "workstation";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
    };
  };

  hardware = {
    pulseaudio.enable = true;
  };
}
