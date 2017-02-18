{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Berlin";

  fonts = {
    enableFontDir = true;

    fonts = with pkgs; [
      bakoma_ttf
      dejavu_fonts
      font-awesome-ttf
      inconsolata
      liberation_ttf
      proggyfonts
      source-sans-pro
      terminus_font
      ttf_bitstream_vera
      ubuntu_font_family
    ];
  };

  environment.variables = {
		GTK_PATH          = "${pkgs.xfce.gtk_xfce_engine}/lib/gtk-2.0";
		GTK_DATA_PREFIX   = "${config.system.path}";
		GIO_EXTRA_MODULES = "${pkgs.xfce.gvfs}/lib/gio/modules";
		GTK_IM_MODULE     = "xim";
		QT_IM_MODULE      = "xim";
  };

  environment.systemPackages = with pkgs; [
    acpi
    apg
    axel
    conkeror
    dzen2
    execline
    haskellPackages.gitHUD
    linuxPackages.cpupower
    mutt
    powertop
    termite
    weechat
    steam
    networkmanagerapplet
    networkmanager_openvpn
    openvpn
    update-resolv-conf
    pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
  ];

  users = {
    mutableUsers = true;
    extraUsers.dejanr = {
      description = "Dejan Ranisavljevic";
      name = "dejanr";
      group = "users";
      extraGroups = [
				"lp" "kmem"
				"wheel" "disk"
				"audio" "video"
				"networkmanager"
				"systemd-journal"
				"vboxusers" "docker"
				"utmp" "adm" "input"
				"tty" "floppy" "uucp"
				"cdrom" "tape" "dialout"
        "libvirtd"
			];
      shell = "/run/current-system/sw/bin/bash";
      home = "/home/dejanr";
      createHome = true;
    };
  };

  users.extraGroups.docker.members = [ "dejanr" ];
  users.extraGroups.vboxusers.members = [ "dejanr" ];

  networking = {
    networkmanager.enable = true;
	  nameservers = [
      "208.67.222.222"
      "208.67.222.220"
    ];
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [ # incoming connections allowed
        22   # ssh
        9418 # tor
      ];
      allowedTCPPortRanges = [];
      allowedUDPPorts = [];
      allowedUDPPortRanges = [];
      connectionTrackingModules = [];
    };
  };

  i18n = {
    consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" "sr_RS@latin/UTF-8" ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;

    opengl.driSupport = true;
    opengl.driSupport32Bit = true;

    firmware = [
      pkgs.firmwareLinuxNonfree
    ];

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
  security.rtkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      var YES = polkit.Result.YES;
      var permission = {
      // required for udisks1:
      "org.freedesktop.udisks.filesystem-mount": YES,
      "org.freedesktop.udisks.luks-unlock": YES,
      "org.freedesktop.udisks.drive-eject": YES,
      "org.freedesktop.udisks.drive-detach": YES,
      // required for udisks2:
      "org.freedesktop.udisks2.filesystem-mount": YES,
      "org.freedesktop.udisks2.encrypted-unlock": YES,
      "org.freedesktop.udisks2.eject-media": YES,
      "org.freedesktop.udisks2.power-off-drive": YES,
      // required for udisks2 if using udiskie from another seat (e.g. systemd):
      "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
      "org.freedesktop.udisks2.filesystem-unmount-others": YES,
      "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
      "org.freedesktop.udisks2.eject-media-other-seat": YES,
      "org.freedesktop.udisks2.power-off-drive-other-seat": YES
      };
      if (subject.isInGroup("wheel")) {
        return permission[action.id];
      }
    });
  '';

	nix = {
    nixPath = [
      "/etc/nixos"
      "nixpkgs=/etc/nixos/nixpkgs"
      "nixos=/etc/nixos/nixpkgs/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
    buildCores = 4;
    extraOptions = ''
      gc-keep-outputs = false
      gc-keep-derivations = false
    '';
  };
}
