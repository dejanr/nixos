{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;


  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
      jre = true;
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };
  };

  environment.systemPackages = with pkgs; [
    ack
    acpi
    bash
    curl
    dmenu
    firefox
    nodejs
    vim
    git
    wget
    nix-repl
    rxvt_unicode
    ruby
    rake
    tree
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
      windowManager.herbstluftwm.enable = true;
      windowManager.default = "herbstluftwm";

      displayManager = {
        slim.enable = true;
        slim.defaultUser = "dejanr";
        # Get lid suspend for minimalist window managers
        desktopManagerHandlesLidAndPower = false;
      };

      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };

      multitouch.enable = true;
      multitouch.ignorePalm = true;

      vaapiDrivers = [ pkgs.vaapiIntel ];
    };
  };

  users = {
    mutableUsers = false;
    extraUsers.dejanr = {
      description = "Dejan Ranisavljevic";
      name = "dejanr";
      group = "users";
      extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
      shell = "/run/current-system/sw/bin/bash";
      home = "/home/dejanr";
      createHome = true;
      hashedPassword = "$6$vj9HMM/LwjXSbkgf$TLrcYrLG0u/ToiCED2LiMKoyCXo/gWjSyIfs.gGIiPQ2oLK1WWix3z05yHfy90rsr1GoHP.Z31UX7O.Vq9BEt0";
    };
    extraUsers.root.hashedPassword = "$6$vj9HMM/LwjXSbkgf$TLrcYrLG0u/ToiCED2LiMKoyCXo/gWjSyIfs.gGIiPQ2oLK1WWix3z05yHfy90rsr1GoHP.Z31UX7O.Vq9BEt0";
  };

  networking = {
    hostName = "mbp";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    wireless.enable = true;
  };

  virtualisation.docker.enable = true;
}
