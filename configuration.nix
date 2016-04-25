# Copy this file to /etc/nixos/configuration.nix
# and import correct configuration
{ config, pkgs, ... }:

{
  imports =
    [
      ./workstation.nix
    ];
}
