{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rofi                         # for app launcher
    rofi-menugen                 # Generates menu based applications using rofi
    feh                          # for background image
    i3blocks                     # sys info
    i3lock-fancy                 # lock session
    scrot                        # screenshot
    shutter                      # Screenshot and annotation tool
    lxqt.screengrab              # Crossplatform tool for fast making screenshots
    xautolock                    # suckless xautolock
    polybar                      # status bar
    xdotool                      # inspect window title
    xorg.utilmacros
    xorg.xcursorgen
    xorg.xcursorthemes
    xorg.xrdb
    xorg.xsetroot
    xorg.xbacklight
    sound-theme-freedesktop
    dunst                        # notifications
    compton                      # window transitions
    i3minator                    # i3 project manager
    xscreensaver                 # screensaver
    xss-lock                     # screensaver
    xfce.thunar                  # file amanger
    xfce.thunar_volman
    xfce.thunar-archive-plugin
    xfce.xfce4-screenshooter
    xfce.gvfs                    # virtual filesystem
    xfce.ristretto               # A fast and lightweight picture-viewer for the Xfce desktop environment
    xfce.tumbler                 # A D-Bus thumbnailer service
    xfce.xfce4icontheme          # Icons for Xfce
    xfce.xfconf                  # Simple client-server configuration storage and query system for Xfce
    gnome3.vte
    gnome3.gnome_keyring
    gnome3.gnome_themes_standard # arc theme
    gnome3.gnome_settings_daemon # makes DPI scaling, fonts and GTK settings come active.
    gnome3.dconf
    arc-icon-theme
    arc-theme
    gtk-engine-murrine           # arc theme
    lxappearance                 # configure theme
    vanilla-dmz                  # cursor theme

    xlibs.libX11
    xlibs.libXinerama
    xlibs.xev
    xlibs.xkill
    xlibs.xmessage

    networkmanagerapplet         # NetworkManager control applet for GNOME
    networkmanager_openvpn       # NetworkManager's OpenVPN plugin
  ];

  services.xserver = {
    enable = true;
    useGlamor = true;
    autorun = true;

    libinput = {
      enable = true;
      disableWhileTyping = true;
      naturalScrolling = true;
    };

    windowManager = {
      i3.enable = true;
      default = "i3";
    };

    desktopManager = {
      default = "lxqt";
      xterm.enable = false;
      lxqt.enable = true;
    };

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
        ${pkgs.compton}/bin/compton --config ~/.compton.conf -b &
        ${pkgs.xautolock}/bin/xautolock -time 15 -locker ~/.bin/lock &
        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr &
        ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources &
        ${pkgs.xorg.xrdb}/bin/xrdb -merge /etc/X11/Xresources &
        ${pkgs.feh}/bin/feh --bg-fill /etc/nixos/wallpapers/lambda2.jpg &
        ${pkgs.networkmanagerapplet}/bin/nm-applet &
        ${pkgs.emacs}/bin/emacs --daemon &
      '';
    };

		multitouch.enable = true;
		multitouch.ignorePalm = true;
		multitouch.invertScroll = true;

		xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };
}
