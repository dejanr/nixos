{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
    minecraft
    playonlinux
    wineStaging
    winetricks
  ];

  services = {
    minecraft-server = {
      enable = false;
    };
  };
}
