{ pkgs, ... }:

let
  credentials = import ../credentials.nix;
in
{
  environment.systemPackages = with pkgs; [
    arandr # manage dispays
    chromium
    evince # gnome document viewer
    firefox
    gnupg # encryption
    gtypist # typing practice
    inkscape # vector graphics editor
    kde4.calligra # suite of producitivity applications
    keepassx2 # password managment
    keychain
    libnotify # send notifications to a notification daemon
    libreoffice
    networkmanagerapplet
    pamixer # cli tools for pulseaudio
    pinentry # gnupg interface to passphrase input
    pidgin # instant messanger
    pidginwindowmerge # merge contacts and message window
    skype4pidgin # use running skype inside pidgin
    scrot # screen capturing
    skype
    tesseract # OCR engine
    transmission # bittorrent client
    unrar
    unzip
    xarchiver
    xclip # clipboard
    xdg_utils # Set of cli tools that assist applications integration
    xfce.gtk_xfce_engine
    xfce.gvfs # virtual filesystem
    xfce.ristretto
    xfce.thunar # file manager
    xfce.thunar_volman
    xfce.tumbler
    xfce.xfce4icontheme
    xfce.xfconf
    xlibs.libX11
    xlibs.libXinerama
    xlibs.xev
    xlibs.xkill
    xlibs.xmessage
    xsel
    xsettingsd
    xss-lock
    zip
    qutebrowser
    transmission
    transmission_gtk
    slic3r
  ];

  services = {
    transmission = {
      enable = true;
      settings = {
        incomplete-dir-enabled = false;
        ratio-limit-enabled = true;
        watch-dir-enabled = true;
        ratio-limit = 2;
        encryption = 2;
        umask = 2;
        speed-limit-up = 1;
        speed-limit-up-enabled = true;
        rpc-whitelist = "127.0.0.1,192.168.*.*";
        rpc-username = credentials.transmission-user;
        rpc-password = credentials.transmission-password;
      };
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
		chromium = {
      proprietaryCodecs = true;
      enableWideVine = true;
      enableNacl = true;
    };
  };
}
