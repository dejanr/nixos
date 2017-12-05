{ config, lib, pkgs, boot, networking, containers, ... }:

{
  networking.firewall.allowedTCPPorts = [ 32400 ];

  fileSystems."/var/lib/plex" = {
    device = "main/nixos/config/plex";
    fsType = "zfs";
  };

  containers.plex = {
    autoStart = true;

    bindMounts = {
      "/var/lib/plex" = {
        hostPath = "/var/lib/plex";
        isReadOnly = false;
      };
      "/downloads" = {
        hostPath = "/mnt/media/downloads";
        isReadOnly = false;
      };
      "/movies" = {
        hostPath = "/mnt/media/movies";
        isReadOnly = false;
      };
      "/tv" = {
        hostPath = "/mnt/media/tv";
        isReadOnly = false;
      };
    };

    config = {
      boot.isContainer = true;

      networking.hostName = "plex";
      networking.firewall.enable = false;
      networking.interfaces.eth0.useDHCP = true;

      nixpkgs.config.allowUnfree = true;

      services.plex = {
        enable = true;
        dataDir = "/var/lib/plex";
      };
    };
  };
}
