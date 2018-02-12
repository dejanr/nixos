{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qemu # A generic and open source machine emulator and virtualizer
    virtmanager # Desktop user interface for managing virtual machines
    vde2 # Virtual Distributed Ethernet, an Ethernet compliant virtual network
    pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
  ];

  virtualisation.libvirtd = {
    enable = true;
  };

  users.extraUsers.dejanr.extraGroups = [ "libvirtd" ];
  networking.firewall.checkReversePath = false;

  virtualisation.virtualbox.host.enable = true;
}
