{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ../roles/common.nix
  ];

  boot = {
    cleanTmpDir = true;
    kernelParams = ["boot.shell_on_fail"];
    kernelModules = [ ];
    extraModulePackages = [ ];

    loader.grub.device = "/dev/sda";
    loader.grub.storePath = "/nixos/nix/store";

    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" ];
    initrd.supportedFilesystems = [ "ext4" ];
    initrd.postDeviceCommands = ''
      mkdir -p /mnt-root/old-root ;
      mount -t ext4 /dev/sda1 /mnt-root/old-root ;
    '';

    loader.grub.enable = true;
    loader.grub.version = 2;
  };

  fileSystems = {
    "/" = {
      device = "/old-root/nixos";
      fsType = "none";
      options = [ "bind" ];
    };

    "/old-root" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
  };

  swapDevices = [ ];

  networking = {
    hostName = "nixos";
  };

  services.openssh.enable = true;

  nix.maxJobs = lib.mkDefault 1;

  system.stateVersion = "18.03";
}
