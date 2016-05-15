{ pkgs, ... }:

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
    scrot # screen capturing
    skype
    spotify
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
  ];

  nixpkgs.config = {
    allowUnfree = true;
		chromium = {
      proprietaryCodecs = true;
      enablePepperFlash = true;
      enablePepperPDF = true;
      enableWideVine = true;
      enableNacl = true;
    };
  };
}
