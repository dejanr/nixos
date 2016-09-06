{ pkgs, ... }:

let
  credentials = import ../credentials.nix;
in
{
  environment.systemPackages = with pkgs; [
    arandr # manage dispays
    chromium
    cura
    electrum # bitcoin thin-client
    evince # gnome document viewer
    firefox
    freecad # General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler
    gnupg # encryption
    google-chrome
    google-drive-ocamlfuse # FUSE-based file system backed by Google Drive
    gtypist # typing practice
    gimp # Image Manipulation Program
    hfsprogs # HFS user space utils, for mounting HFS+ osx partitions
    inkscape # vector graphics editor
    kde4.calligra # suite of producitivity applications
    keepassx2 # password managment
    keychain
    libnotify # send notifications to a notification daemon
    libreoffice
    meshlab # Processing and editing of unstructured 3D triangular meshes
    networkmanagerapplet
    openscad # 3D parametric model compiler
    pamixer # cli tools for pulseaudio
    pcmanfm # File manager witth GTK+ interface
    pidgin-skypeweb
    pidgin-with-plugins
    pidginwindowmerge # merge contacts and message window
    pinentry # gnupg interface to passphrase input
    polkit # A dbus session bus service that is used to bring up authentication dialogs
    printrun # 3d printing host software
    purple-plugin-pack
    pythonPackages.udiskie # Removable disk automounter for udisks
    pythonPackages.youtube-dl # Command-line tool to download videos from YouTube.com and other sites
    qalculate-gtk # The ultimate desktop calculator
    qutebrowser # keyboard focused browser with minimal GUI
    scrot # screen capturing
    skype
    skype4pidgin # use running skype inside pidgin
    slic3r # G-code generator for 3D printers
    sxiv # image viewer
    surf # suckless browser
    tesseract # OCR engine
    thunderbird # email client
    transmission # bittorrent client
    transmission_gtk
    unrar
    unzip
    utox
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
    zip
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
    nixpkgs.config.packageOverrides = pkgs: {
      inherit (import ./packages { inherit pkgs; }) custom;
    };
  };
}
