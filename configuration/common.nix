{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Berlin";

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

  nixpkgs.config = {
    allowUnfree = true;
    chromium = {
      enablePepperPDF = true;
      enableWideVine = true;
    };
  };

  environment.systemPackages = with pkgs; [
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
    chromium
    dmenu
    dzen2
    emacs
    file
    firefox
    feh
    mutt
    mplayer
    nodejs
    vim
    git
    gitFull
    gitAndTools.git-extras
    go
    htop
    execline
    irssi
    weechat
    wget
    nix-repl
    openssl
    powertop
    python
    ruby
    silver-searcher
    termite
    gnome3.vte
    tree
    tmux
    linuxPackages.cpupower
    unzip
    zathura
    xdg_utils
  ];

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
  users.extraGroups.vboxusers.members = [ "dejanr" ];

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "yes";
    };

    acpid.enable = true;

    xserver = {
      enable = true;
      driSupport = true;
      useGlamor = true;

      displayManager = {
        slim.enable = true;
        slim.defaultUser = "dejanr";
        slim.autoLogin = true;

        desktopManagerHandlesLidAndPower = false;

        sessionCommands = ''
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

      multitouch.enable = true;
      multitouch.ignorePalm = true;
      multitouch.invertScroll = true;

      xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
    };

    upower.enable = true;
    nixosManual.showManual = true;

    # synchronize time using chrony
    ntp.enable = false;
    chrony.enable = true;
  };
}
