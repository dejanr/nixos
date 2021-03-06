{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  time.timeZone = "Europe/Berlin";

  environment.variables = {
  };

  environment.systemPackages = with pkgs; [
    apg # Tools for random password generation
    haskellPackages.gitHUD # command-line HUD for git repos
    linuxPackages.cpupower # Tool to examine and tune power saving features
    wget # Tool for retrieving files
    neovim
    vimHugeX
    rsync #	A fast incremental file transfer utility
    unzip # An extraction utility for archives compressed in .zip format
    zip # Compressor/archiver for creating and modifying zipfiles
    gitAndTools.gitFull # Distributed version control system
    htop # An interactive process viewer for Linux
    pixz # A parallel compressor/decompressor for xz format
    psmisc # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
    pwgen # Password generator which creates passwords which can be easily memorized by a human
    tmux # Terminal multiplexer
    bc # GNU software calculator
    nixops # NixOS cloud provisioning and deployment tool
    rxvt
    rxvt_unicode
    urxvt_vtwheel
    urxvt_font_size
    urxvt_perl
    urxvt_perls
    font-manager # Simple font management for GTK+ desktop environments
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
        "adbusers"
			];
      shell = "/run/current-system/sw/bin/bash";
      home = "/home/dejanr";
      createHome = true;
    };
  };

  services.openssh.authorizedKeysFiles = ["/home/dejanr/.ssh/authorized_keys" "/etc/nixos/authorized_keys"];

  programs.mosh.enable = true;
  programs.vim.defaultEditor = true;
  programs.ssh.startAgent = true;

  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ # incoming connections allowed
        22   # ssh
        9418 # tor
        25565 # minecraft server
        80
        443
        3000
        4000
        5000
      ];
      allowedTCPPortRanges = [];
      allowedUDPPorts = [];
      allowedUDPPortRanges = [];
      connectionTrackingModules = [];
    };
  };

  i18n = {
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

  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "4096";
  }];

  nixpkgs.config = {
    android_sdk.accept_license = true;
    config.allowBroken = true;

    permittedInsecurePackages = [
      "webkitgtk-2.4.11"
    ];


    # Create an alias for the unstable channel
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

	nix = {
    useSandbox = false;
    extraOptions = ''
      gc-keep-outputs = false
      gc-keep-derivations = false
      auto-optimise-store = true
    '';
  };
}
