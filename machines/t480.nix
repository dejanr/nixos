{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../roles/common.nix
      ../roles/desktop.nix
      ../roles/i3.nix
      ../roles/autolock.nix
      ../roles/multimedia.nix
      ../roles/development.nix
      ../roles/services.nix
      ../roles/fonts.nix
   ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      luks.devices.decrypted-hdd = {
        device = "/dev/disk/by-id/nvme-WDC_PC_SN720_SDAQNTW-512G-1001_184791804261-part2";
        keyFile = "/keyfile.bin";
      };
    };

    kernelModules = [
      "acpi_call"
      "kvm-intel"
      "i915"
    ];

    blacklistedKernelModules = [
      "fbcon"
      "noveau"
      "bbswitch"
    ];

    kernelParams = [
      "i915.enable_fbc=1"
      "i915.enable_psr=2"
    ];

    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };

    supportedFilesystems = [ "zfs" ];
    cleanTmpDir = true;

    loader = {
      efi.efiSysMountPoint = "/efi";

      grub = {
      device = "nodev";
      efiSupport = true;
      extraInitrd = "/boot/initrd.keys.gz";
      enableCryptodisk = true;
      zfsSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };

  fileSystems."/" =
    { device = "zroot/root";
      fsType = "zfs";
    };

  fileSystems."/efi" =
    { device = "/dev/disk/by-id/nvme-WDC_PC_SN720_SDAQNTW-512G-1001_184791804261-part1";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking = {
    hostName = "theory";
    hostId = "7392bf5d";
  };

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];

  services = {
    xserver = {
      enable = true;
      enableTCP = false;
      modules = [ pkgs.xf86_input_mtrack ];
      videoDrivers = [ "intel" ];

      monitorSection = ''
        DisplaySize 342 192
      '';
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

  # Temporary fix for cpu throttling issues visible in the kernel log
  # (journalctl -k) by setting the same temperature limits used by
  # Window$
  # See https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues
  systemd.services.cpu-throttling = {
    enable = true;
    description = "Sets the offset to 3 °C, so the new trip point is 97 °C";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    path = [ pkgs.msr-tools ];
    script = "wrmsr -a 0x1a2 0x3000000";
    serviceConfig = {
      Type = "oneshot";
    };
    wantedBy = [
      "timers.target"
    ];
  };

  systemd.timers.cpu-throttling = {
    enable = true;
    description = "Set cpu heating limit to 97 °C";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    timerConfig = {
      OnActiveSec = 60;
      OnUnitActiveSec = 60;
      Unit = "cpu-throttling.service";
    };
    wantedBy = [
      "timers.target"
    ];
  };

  nix.maxJobs = lib.mkDefault 8;

  system.stateVersion = "18.09";
}

