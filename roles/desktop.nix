{ pkgs, ... }:

let
  secrets = import ../secrets.nix;
in
{
  environment.systemPackages = with pkgs; [
    acpi # Show battery status and other ACPI information
    arandr # manage dispays
    axel #  Console downloading program with some features for parallel connections for faster downloading
    chromium # An open source web browser from Google
    corebird # twitter client
    cura # 3D printer / slicing GUI built on top of the Uranium framework
    electrum # bitcoin thin-client
    evince # gnome document viewer
    firefox # A web browser built from Firefox source tree
    gimp # Image Manipulation Program
    gnupg # encryption
    google-chrome # google chrome browser
    google-drive-ocamlfuse # FUSE-based file system backed by Google Drive
    gtypist # typing practice
    hfsprogs # HFS user space utils, for mounting HFS+ osx partitions
    inkscape # vector graphics editor
    keepassx2 # password managment
    keychain # Keychain management tool
    libnotify # send notifications to a notification daemon
    libreoffice # Comprehensive, professional-quality productivity suite
    lm_sensors # Tools for reading hardware sensors
    mutt # A small but very powerful text-based mail client
    openscad # 3D parametric model compiler
    openvpn # A robust and highly flexible tunneling application
    pciutils # lspci and other utils
    pcmanfm # File manager witth GTK+ interface
    pidgin-with-plugins # Multi-protocol instant messaging client
    pidginwindowmerge # merge contacts and message window
    pinentry # gnupg interface to passphrase input
    polkit # A dbus session bus service that is used to bring up authentication dialogs
    powertop # Analyze power consumption on Intel-based laptops
    printrun # 3d printing host software
    purple-plugin-pack # Plugin pack for Pidgin 2.x
    pythonPackages.youtube-dl # Command-line tool to download videos from YouTube.com and other sites
    qalculate-gtk # The ultimate desktop calculator
    scrot # screen capturing
    slack # slack desktop client
    slic3r-prusa3d # G-code generator for 3D printer
    surf # suckless browser
    sxiv # image viewer
    termite # A simple VTE-based terminal
    tesseract # OCR engine
    thunderbird # email client
    tigervnc # Fork of tightVNC, made in cooperation with VirtualGL
    transmission-gtk
    udiskie # Removable disk automounter for udisks
    unrar
    update-resolv-conf # Script to update your /etc/resolv.conf with DNS settings that come from the received push dhcp-options pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
    utox # Lightweight Tox client
    weechat # A fast, light and extensible chat client
    xarchiver # GTK+ frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)
    xclip # clipboard
    xdg_utils # Set of cli tools that assist applications integration
    xpdf # pdf viewer
    xsel # Command-line program for getting and setting the contents of the X selection
    xsettingsd # Provides settings to X11 applications via the XSETTINGS specification
    zathura # pdf viewer
    zoom-us # zoom.us desktop app
    magic-wormhole # Securely transfer data between computers
    transporter # Simple magic-wormhole client
    kazam	# A screencasting program created with design in mind
  ];

  nixpkgs.config = {
    allowUnfree = true;
    nixpkgs.config.packageOverrides = pkgs: {
      inherit (import ../packages { inherit pkgs; }) custom;
    };
  };
}
