{ pkgs, ... }:

{
  environment.x11Packages = with pkgs; [
    rofi         # for app launcher
    feh          # for background image
    i3lock       # screen lock
    i3blocks     # sys info
    scrot        # screenshot

    # xorg.utilmacros
    # xorg.xcursorgen
    # xorg.xcursorthemes
  ];

  environment.systemPackages = with pkgs; [
    xscreensaver # screensaver
    xss-lock # screensaver
    xfce.thunar # file amanger
    xfce.thunar_volman
    xfce.thunar-archive-plugin
    gnome.gnome_icon_theme # arc theme
    gnome3.gnome_themes_standard # arc theme
    gtk-engine-murrine # arc theme
    arc-gtk-theme
    lxappearance # configure theme
    arandr # manage dispays
    pavucontrol # volume control
    vanilla-dmz # cursor theme
  ];

  hardware.opengl.driSupport32Bit = true;

  services.xserver = {
    enable = true;
    autorun = true;

    windowManager = {
      i3.enable = true;
      default = "i3";
    };

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager = {
      slim.enable = true;

      sessionCommands = ''
        i3status &
      '';
    };
  };
}
