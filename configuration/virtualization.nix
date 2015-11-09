{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    linuxPackages.virtualbox
  ];

  virtualisation.virtualbox = {
    host.enable = true;
  };
}
