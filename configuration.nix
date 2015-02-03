{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_3_17;

    loader.gummiboot.enable = true;
    loader.gummiboot.timeout = 3;
    loader.efi.canTouchEfiVariables = true;

    cleanTmpDir = true;
  };


  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;

    fonts = with pkgs; [
      inconsolata
      ubuntu_font_family
      dejavu_fonts
      liberation_ttf
      proggyfonts
      source-sans-pro
      terminus_font
      ttf_bitstream_vera
    ];
  };

  nix.binaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];

  nixpkgs.config = {
    allowUnfree = true;

    firefox = {
      jre = true;
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # window management
    stumpwm
    compton
    xlaunch

    # system
    ack
    acpi
    alsaLib
    alsaUtils
    alsaPlugins
    apg
    autojump
    axel
    bind
    binutils
    bash
    curl
    conkeror
    dmenu
    dzen2
    emacs
    file
    firefox
    nodejs
    vimHugeX
    git
    gitFull
    gitAndTools.git-extras
    go
    htop
    execline
    irssi
    wget
    nodejs
    nix-repl
    openssl
    powertop
    pidgin
    python
    skype4pidgin
    ruby
    rake
    silver-searcher
    terminator
    tree
    tmux
    wpa_supplicant_gui
    xdg_utils
    xlibs.xev
    xlibs.xset
    xlibs.xmodmap
    xclip
    linuxPackages_3_17.cpupower
    unzip
  ];

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "yes";
    };

    acpid.enable = true;

    xserver = {
      enable = true;
      videoDrivers = [ "intel" ];
      driSupport = true;

      desktopManager.default = "none";
      desktopManager.xterm.enable = false;
      desktopManager.xfce.enable = false;

      windowManager.stumpwm.enable = true;
      windowManager.default = "stumpwm";

      useGlamor = true;

      displayManager = {
        slim.enable = true;
        slim.defaultUser = "dejanr";
        slim.autoLogin = true;

        desktopManagerHandlesLidAndPower = false;

        sessionCommands = ''
          xrdb -merge ~/.Xdefaults;
          xsetroot -solid dark;
          xmodmap ~/.Xmodmap
          xsetroot -cursor_name left_ptr;
          xsetroot general;
        '';
      };

      synaptics = {
        enable = true;
        additionalOptions = ''
          Option "VertScrollDelta" "-100"
          Option "HorizScrollDelta" "-100"
          Option "PalmMinWidth" "8"
          Option "PalmMinZ" "100"
        '';
        buttonsMap = [ 1 3 2 ];
        tapButtons = false;
        palmDetect = true;
        fingersMap = [ 0 0 0 ];
        twoFingerScroll = true;
        vertEdgeScroll = false;
      };

      screenSection = ''
        Option "DPI" "96 x 96"
      '';

      multitouch.enable = true;
      multitouch.ignorePalm = true;
      multitouch.invertScroll = true;

      vaapiDrivers = [ pkgs.vaapiIntel ];

      xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
    };

    upower.enable = true;
    nixosManual.showManual = true;
  };

  security.setuidPrograms = [ "xlaunch" ];

  users = {
    mutableUsers = true;
    extraUsers.dejanr = {
      description = "Dejan Ranisavljevic";
      name = "dejanr";
      group = "users";
      extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
      shell = "/run/current-system/sw/bin/bash";
      home = "/home/dejanr";
      createHome = true;
    };
  };

  users.extraGroups.docker.members = [ "dejanr" ];

  networking = {
    hostName = "mbp";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    wireless.enable = true;
  };

  virtualisation.docker.enable = true;
}
