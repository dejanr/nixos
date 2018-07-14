{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../roles/common.nix
      ../roles/desktop.nix
      ../roles/xmonad.nix
      ../roles/multimedia.nix
      ../roles/development.nix
      ../roles/services.nix
   ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      luks.devices = [
       {
         name = "nixos-root";
         device = "/dev/sda3";
       }
      ];
    };
    kernelModules = [ "kvm-intel" ];
    kernelParams = [
      "hid_apple.fnmode=2"
    ];

    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };

    extraModulePackages = [
      config.boot.kernelPackages.broadcom_sta
      config.boot.kernelPackages.v4l2loopback
    ];

    extraModprobeConfig = ''
      options libata.force=noncq
      options snd_hda_intel index=0 model=intel-mac-auto id=PCH
      options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
      options snd_hda_intel model=mbp101
      options hid_apple fnmode=2
    '';

    supportedFilesystems = [ "zfs" ];

    loader = {
      systemd-boot.enable = true;
      generationsDir.enable = false;
      generationsDir.copyKernels = false;
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };

    cleanTmpDir = true;
  };

  fileSystems."/" =
    { device = "main/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "main/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/ABE6-1EE4";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/zd0"; }
    ];

  networking = {
    hostName = "mbp";
    hostId = "8425e349";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  services = {
    # Repurpose power key, bincode 124
    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';

    xserver = {
      enable = true;
      enableTCP = false;
      modules = [ pkgs.xf86_input_mtrack ];
      videoDrivers = [ "intel" ];
      dpi = 190;
      xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";

      config =
        ''
          Section "InputClass"
            MatchIsTouchpad "on"
            Identifier      "Touchpads"
            Driver          "mtrack"
            Option          "Sensitivity" "0.64"
            Option          "FingerHigh" "5"
            Option          "FingerLow" "1"
            Option          "IgnoreThumb" "true"
            Option          "IgnorePalm" "true"
            Option          "DisableOnPalm" "true"
            Option          "TapButton1" "1"
            Option          "TapButton2" "3"
            Option          "TapButton3" "2"
            Option          "TapButton4" "0"
            Option          "ClickFinger1" "1"
            Option          "ClickFinger2" "2"
            Option          "ClickFinger3" "3"
            Option          "ButtonMoveEmulate" "false"
            Option          "ButtonIntegrated" "true"
            Option          "ClickTime" "25"
            Option          "BottomEdge" "50"
            Option          "SwipeLeftButton" "8"
            Option          "SwipeRightButton" "9"
            Option          "SwipeUpButton" "0"
            Option          "SwipeDownButton" "0"
            Option          "ScrollDistance" "75"
            Option          "VertScrollDelta" "-111"
            Option          "HorizScrollDelta" "-111"
        EndSection
        '';

      multitouch = {
        enable = false;
        invertScroll = true;
      };

      synaptics = {
        enable = false;
        horizontalScroll = true;
        minSpeed = "0.7";
        palmDetect = true;
        twoFingerScroll = true;
        additionalOptions = ''
          Option "VertScrollDelta"     "-111"
          Option "HorizScrollDelta"    "-111"
          Option "AreaBottomEdge"      "4000"
        '';
      };

      displayManager = {
        xserverArgs = [ "-dpi 92" ];
      };
    };

    mbpfan = {
      enable = true;
      lowTemp = 55;
      highTemp = 65;
      maxTemp = 70;
      minFanSpeed = 3500;
    };
  };

  environment = {
    etc."X11/Xresources".text = ''
      Xft.dpi: 190
    '';
    variables.QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    variables.GDK_SCALE = "2";
    variables.GDK_DPI_SCALE = "0.5";
  };

  programs.light.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";

  nix.maxJobs = lib.mkDefault 8;

  system.stateVersion = "18.03";
}
