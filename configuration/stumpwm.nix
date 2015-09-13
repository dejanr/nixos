{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    stumpwm
    compton
  ];

  services.xserver = {
    enable = true;
    layout = "us";

    windowManager.stumpwm.enable = true;
    windowManager.default = "stumpwm";
    desktopManager.xterm.enable = false;
    desktopManager.default = "none";
  };
}
