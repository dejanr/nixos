{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rofi         # for app launcher
    rofi-menugen # Generates menu based applications using rofi
    feh          # for background image
    i3blocks     # sys info
    scrot        # screenshot
    xautolock    # suckless xautolock

    xorg.utilmacros
    xorg.xcursorgen
    xorg.xcursorthemes
    xorg.xrdb
    xorg.xsetroot

    dunst # notifications
    compton # window transitions

    i3minator # i3 project manager

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
    vanilla-dmz # cursor theme
    kde4.oxygen_icons
    kde4.kwin_styles
    oxygen-gtk2
    oxygen-gtk3
    gnome3.adwaita-icon-theme
    gnome3.dconf
  ];

  environment.shellInit = ''
    export GTK_PATH=$GTK_PATH:${pkgs.oxygen_gtk}/lib/gtk-2.0
    export GTK2_RC_FILES=$GTK2_RC_FILES:${pkgs.oxygen_gtk}/share/themes/oxygen-gtk/gtk-2.0/gtkrc
  '';

  services.xserver = {
    enable = true;
    useGlamor = true;
    autorun = true;

    libinput = {
      naturalScrolling = true;
    };

    windowManager = {
      i3-gaps.enable = true;
      default = "i3-gaps";
    };

    desktopManager = {
      default = "none";
      xterm.enable = false;
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
        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xorg.xsetroot}/bin/xsetroot general
        ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
        ${pkgs.xorg.xrdb}/bin/xrdb -merge /etc/X11/Xresources
        ${pkgs.feh}/bin/feh --randomize --bg-fill /etc/nixos/wallpapers/* &
        ${pkgs.networkmanagerapplet}/bin/nm-applet &
        ${pkgs.emacs}/bin/emacs --daemon &
      '';
    };

		synaptics = {
			enable = true;
			palmDetect = true;
			palmMinWidth = 200;
			fingersMap = [ 0 0 0 ];
			horizTwoFingerScroll = true;
		};

		multitouch.enable = true;
		multitouch.ignorePalm = true;
		multitouch.invertScroll = true;

		xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };
}
