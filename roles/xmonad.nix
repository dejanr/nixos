{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rofi                         # for app launcher
    rofi-menugen                 # Generates menu based applications using rofi

    scrot
    trayer
    dunst                        # notifications
    compton                      # window transitions
    xautolock                    # suckless xautolock
    shutter                      # Screenshot and annotation tool
    scrot                        # screenshot
    feh                          # for background image

    xorg.xsetroot
    xorg.utilmacros
    xorg.xcursorgen
    xorg.xcursorthemes
    xorg.xrdb
    xorg.xsetroot
    xorg.xbacklight
    sound-theme-freedesktop

    arc-icon-theme
    arc-theme
    vanilla-dmz                  # cursor theme

    xlibs.libX11
    xlibs.libXinerama
    xlibs.xev
    xlibs.xkill
    xlibs.xmessage

    networkmanagerapplet         # NetworkManager control applet for GNOME
    networkmanager_openvpn       # NetworkManager's OpenVPN plugin

    haskellPackages.xmobar
    haskellPackages.taffybar

    xsettingsd # Provides settings to X11 applications via the XSETTINGS specification
    wmctrl # Command line tool to interact with an EWMH/NetWM compatible X Window Manager
  ];

  services.xserver = {
    enable = true;
    layout = "us";

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    windowManager.default = "xmonad";

    #windowManager.i3.enable = true;
    #windowManager.default = "i3";

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;

    displayManager = {
      slim = {
        enable = true;
        defaultUser = "dejanr";
        theme = pkgs.fetchurl {
          url = "https://github.com/edwtjo/nixos-black-theme/archive/v1.0.tar.gz";
          sha256 = "13bm7k3p6k7yq47nba08bn48cfv536k4ipnwwp1q1l2ydlp85r9d";
        };
      };

      sessionCommands = ''
        ${pkgs.dunst}/bin/dunst &
        ${pkgs.compton}/bin/compton --config ~/.comptonrc -b &
        ${pkgs.xautolock}/bin/xautolock -time 15 -locker ~/.bin/lock &
        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr &
        ${pkgs.xorg.xrdb}/bin/xrdb -DSOLARIZED_DARK -load ~/.Xresources &
        ${pkgs.xsettingsd}/bin/xsettingsd &
        ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource modesetting NVIDIA-0 &
        ${pkgs.xorg.xrandr}/bin/xrandr --dpi 96 &
        $HOME/.bin/wm/displayctl &
        ${pkgs.feh}/bin/feh --bg-fill /etc/nixos/wallpapers/black-low-poly.jpg &
        ${pkgs.networkmanagerapplet}/bin/nm-applet &
        ${pkgs.emacs}/bin/emacs --daemon &
      '';
    };
    modules = [ pkgs.xf86_input_mtrack ];

    config =
      ''
        Section "InputClass"
          MatchIsTouchpad "on"
          Identifier      "Touchpads"
          Driver "mtrack"
          Option "Sensitivity" "0.55"
          Option "FingerHigh" "12"
          Option "FingerLow" "1"
          Option "IgnoreThumb" "true"
          Option "IgnorePalm" "true"
          Option "TapButton1" "1"
          Option "TapButton2" "3"
          Option "TapButton3" "2"
          Option "TapButton4" "0"
          Option "ClickFinger1" "1"
          Option "ClickFinger2" "3"
          Option "ClickFinger3" "0"
          Option "ButtonMoveEmulate" "false"
          Option "ButtonIntegrated" "true"
          Option "ClickTime" "25"
          Option "BottomEdge" "25"
          Option "ScrollUpButton" "5"
          Option "ScrollDownButton" "4"
          Option "ScrollLeftButton" "7"
          Option "ScrollRightButton" "6"
          Option "SwipeLeftButton" "8"
          Option "SwipeRightButton" "9"
          Option "SwipeUpButton" "0"
          Option "SwipeDownButton" "0"
          Option "ScrollDistance" "75"
        EndSection
      '';

    multitouch = {
      enable = false;
      invertScroll = true;
    };

    synaptics = {
      enable = false;
      horizontalScroll = true;
      minSpeed = "0.7";
      palmDetect = true;
      twoFingerScroll = true;
      additionalOptions = ''
        Option "VertScrollDelta"     "-111"
        Option "HorizScrollDelta"    "-111"
        Option "AreaBottomEdge"      "4000"
      '';
    };
  };
}
