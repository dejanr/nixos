{ config, pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  boot.loader.grub.device = "/dev/sda";
  boot.initrd.checkJournalingFS = false;

  networking.hostName = "nixos";
  networking.proxy.default = null;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/cbed38da-a50a-40e0-8cf8-faf1b4d9256c";
      fsType = "ext4";
    };

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.docker.enable = true;
  services.openssh.enable = true;

  imports = [
		../roles/common.nix
		../roles/desktop.nix
		../roles/i3.nix
		../roles/development.nix
  ];
}
