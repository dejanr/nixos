{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qemu # A generic and open source machine emulator and virtualizer
    virtmanager # Desktop user interface for managing virtual machines
    vde2 # Virtual Distributed Ethernet, an Ethernet compliant virtual network
    pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
    OVMF # Sample UEFI firmware for QEMU and KVM
  ];

  virtualisation.libvirtd = {
    enable = true;
  };

  users.groups.libvirtd.members = [ "root" "dejanr" ];
  users.extraUsers.dejanr.extraGroups = [ "libvirtd" ];
  networking.firewall.checkReversePath = false;

  virtualisation.virtualbox.host.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };


  # CHANGE: use
  #     ls /nix/store/*OVMF*/FV/OVMF{,_VARS}.fd | tail -n2 | tr '\n' : | sed -e 's/:$//'
  # to find your nix store paths
  virtualisation.libvirtd.qemuVerbatimConfig = ''
    nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
  '';
}
