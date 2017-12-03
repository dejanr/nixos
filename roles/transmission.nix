{ pkgs, ... }:

{
  fileSystems."/var/lib/transmission/incomplete" = {
    device = "main/nixos/downloads";
    fsType = "zfs";
  };

  environment.systemPackages = with pkgs; [
    transmission_gtk
  ];

  services.transmission.enable = true;
  services.transmission.settings = {
    download-dir = "/mnt/media/downloads";
    incomplete-dir-enabled = true;
    incomplete-dir = "/var/lib/transmission/incomplete";
    ratio-limit-enabled = true;
    ratio-limit = 0;
    encryption = 2;
    umask = 0;
    speed-limit-up-enabled = true;
    speed-limit-up = 1;
    idle-seeding-limit-enabled = true;
    idle-seeding-limit = 0;
    rpc-whitelist = "127.0.0.1,192.168.*.*";
  };

  networking.firewall.allowedTCPPorts = [ 9091 51413 ];
  networking.firewall.allowedUDPPorts = [ 51413 ];
}
