{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    minecraft
  ];

  services = {
    minecraft-server = {
      enable = false;
    };
  };
}
