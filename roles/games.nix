{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
    minecraft
  ];

  services = {
    minecraft-server = {
      enable = false;
    };
  };
}
