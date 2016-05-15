{ pkgs, ... }:

{
  environment.x11Packages = with pkgs; [
    rofi         # for app launcher
    feh          # for background image
    i3lock       # screen lock
    i3blocks     # sys info
    scrot        # screenshot

    xorg.utilmacros
    xorg.xcursorgen
    xorg.xcursorthemes
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
    vanilla-dmz # cursor theme
    kde4.oxygen_icons
    kde4.kwin_styles
    oxygen-gtk2
    oxygen-gtk3
    gnome3.adwaita-icon-theme
  ];

  environment.shellInit = ''
    export GTK_PATH=$GTK_PATH:${pkgs.oxygen_gtk}/lib/gtk-2.0
    export GTK2_RC_FILES=$GTK2_RC_FILES:${pkgs.oxygen_gtk}/share/themes/oxygen-gtk/gtk-2.0/gtkrc
  '';

  services.xserver = {
    enable = true;
		driSupport = true;
		useGlamor = true;
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

			slim.defaultUser = "dejanr";
			slim.autoLogin = true;

			sessionCommands = ''
				xsetroot -cursor_name left_ptr
				xsetroot general
				emacs --daemon &
				xrdb -merge /etc/X11/Xresources
				xrdb -merge ~/.Xresources
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
