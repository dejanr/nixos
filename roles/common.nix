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
    apg # Tools for random password generation
    haskellPackages.gitHUD # command-line HUD for git repos
    linuxPackages.cpupower # Tool to examine and tune power saving features
    wget # Tool for retrieving files
    vim # The most popular clone of the VI editor
    rsync #	A fast incremental file transfer utility
    unzip # An extraction utility for archives compressed in .zip format
    zip # Compressor/archiver for creating and modifying zipfiles
    gitAndTools.gitFull # Distributed version control system
    htop # An interactive process viewer for Linux
    pixz # A parallel compressor/decompressor for xz format
    psmisc # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
    pwgen # Password generator which creates passwords which can be easily memorized by a human
    tmux # Terminal multiplexer
    nixops # NixOS cloud provisioning and deployment tool
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
        "transmission" "plex"
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
      "8.8.4.4"
      "8.8.8.8"
    ];
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

  nixpkgs.config.permittedInsecurePackages = [
    "webkitgtk-2.4.11"
  ];


	nix = {
    buildCores = 0;
    nixPath = [
      "/etc/nixos"
      "nixpkgs=/etc/nixos/nixpkgs"
      "nixos=/etc/nixos/nixpkgs/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
    ];

    extraOptions = ''
      gc-keep-outputs = false
      gc-keep-derivations = false
    '';

    extraOptions = ''
      auto-optimise-store = true
    '';
  };
}
