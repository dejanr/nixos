{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./configuration/common.nix
      ./configuration/desktop.nix
      ./configuration/i3.nix
    ];

  boot = {
    initrd.availableKernelModules = [ "xhci_hcd" "ahci" "usb_storage" "usbhid" ];
    kernelModules = [ "kvm-intel" "wl" ];

    extraModulePackages = [
      config.boot.kernelPackages.broadcom_sta
      config.boot.kernelPackages.v4l2loopback
    ];

    extraModprobeConfig = ''
      options libata.force=noncq
      options resume=/dev/sda5
      options snd_hda_intel index=0 model=intel-mac-auto id=PCH
      options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
      options snd_hda_intel model=mbp101
      options hid_apple fnmode=2
    '';

    loader = {
      gummiboot.enable = true;
      gummiboot.timeout = 2;
      generationsDir.enable = false;
      generationsDir.copyKernels = false;
      efi.canTouchEfiVariables = true;
    };

    cleanTmpDir = true;
  };

  fileSystems."/" =
    { device = "tank/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/sda4";
      fsType = "vfat";
    };

  networking = {
    hostName = "laptop";
    hostId = "8425e349";
  };

  hardware.bluetooth.enable = false;

  services = {
    xserver = {
      videoDrivers = [ "intel" ];
      vaapiDrivers = [ pkgs.vaapiIntel ];
      displayManager.xserverArgs = [ "-dpi 192" ];
    };

    acpid = {
      acEventCommands = ''
        if [ `cat /sys/class/power_supply/ADP1/online` -eq 0 ]; then
          /run/current-system/sw/bin/cpupower frequency-set -u 1.50GHz
          tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor <<< powersave
        else
          /run/current-system/sw/bin/cpupower frequency-set -u 3.00GHz
          tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor <<< performance
        fi
      '';
    };
  };

  environment = {
    etc."X11/Xresources".text = ''
      Xft.dpi: 192
    '';

    variables.QT_DEVICE_PIXEL_RATIO = "2";
    variables.GDK_SCALE = "2";
    variables.GDK_DPI_SCALE = "0.5";
  };

  programs.light.enable = true;

  swapDevices = [ ];
  nix.maxJobs = 4;

  system.stateVersion = "16.09";
}
