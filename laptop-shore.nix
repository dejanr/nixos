{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./configuration/common.nix
      ./configuration/desktop.nix
      ./configuration/i3.nix
      ./configuration/multimedia.nix
      ./configuration/development.nix
      ./configuration/services.nix
    ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" "wl" ];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };

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
      systemd-boot.enable = true;
      generationsDir.enable = false;
      generationsDir.copyKernels = false;
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };

    cleanTmpDir = true;
  };

  fileSystems."/" =
    { device = "zpool/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C1FD-131B";
      fsType = "vfat";
    };

  networking = {
    hostName = "laptop";
    hostId = "8425e349";
  };

  hardware.bluetooth.enable = false;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  services = {
    xserver = {
      videoDrivers = [ "intel" ];

      displayManager.xserverArgs = [ "-dpi 227" ];
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

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";

  swapDevices = [ ];
  nix.maxJobs = 4;

  system.stateVersion = "16.09";
}
