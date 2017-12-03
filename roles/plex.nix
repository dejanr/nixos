{ config, lib, pkgs, boot, networking, containers, ... }:

{
  networking.firewall.allowedTCPPorts = [ 32400 ];

  fileSystems."/var/lib/plex" = {
    device = "main/nixos/config/plex";
    fsType = "zfs";
  };

  services.plex = {
    enable = true;
    dataDir = "/var/lib/plex";
  };
}
