{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dmenu
    scrot
    trayer
  ];

  services.xserver = {
    enable = true;
    layout = "us";

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    windowManager.default = "xmonad";

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
  };
}
