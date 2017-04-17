{ pkgs, ... }:

let
  credentials = import ../credentials.nix;
in
{
  environment.systemPackages = with pkgs; [
    transmission # bittorrent client
    transmission_gtk
  ];

  services = {
    transmission = {
      enable = true;
      settings = {
        incomplete-dir-enabled = false;
        watch-dir-enabled = true;
        ratio-limit-enabled = true;
        ratio-limit = 0;
        encryption = 2;
        umask = 2;
        speed-limit-up-enabled = true;
        speed-limit-up = 1;
        idle-seeding-limit-enabled = true;
        idle-seeding-limit = 0;
        rpc-whitelist = "127.0.0.1,192.168.*.*";
        rpc-username = credentials.transmission-user;
        rpc-password = credentials.transmission-password;
        trash-original-torrent-filesA = true;
        port-forwarding-enabled = true;
      };
    };

    plex = {
      enable = true;
      openFirewall = true;
      group = "transmission";
    };
  };
}
