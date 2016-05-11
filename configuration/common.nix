{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Berlin";

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;

    fonts = with pkgs; [
      corefonts
      bakoma_ttf
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
    feh
    haskellPackages.gitHUD
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
    xdg_utils
    xsettingsd
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

  networking = {
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    networkmanager.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "yes";
    };

    logind.extraConfig = ''
      HandlePowerKey=ignore
      HandleSuspendKey=ignore
      HandleHibernateKey=ignore
    '';

    acpid = {
      enable = true;

      powerEventCommands = ''
        systemctl suspend
      '';

      lidEventCommands = ''
        systemctl hibernate
      '';
    };

    xserver = {
      enable = true;
      driSupport = true;
      useGlamor = true;

      displayManager = {
        slim.enable = true;
        slim.defaultUser = "dejanr";
        slim.autoLogin = true;

        sessionCommands = ''
          xsetroot -cursor_name left_ptr;
          xsetroot general;
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

    upower.enable = true;
    nixosManual.showManual = true;

    # synchronize time using chrony
    ntp.enable = false;
    chrony.enable = true;

    locate.enable = true;
    mpd.enable = true;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };
}
