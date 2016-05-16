{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Berlin";

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;

    fonts = with pkgs; [
      bakoma_ttf
      corefonts
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
    gnome3.vte
    haskellPackages.gitHUD
    linuxPackages.cpupower
    mutt
    powertop
    termite
    weechat
    steam
    gnome3.dconf
    networkmanagerapplet
    networkmanager_openvpn
    openvpn
    update-resolv-conf
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
  };

  services = {
		printing.enable = true;
		avahi.enable = true;
		locate = {
      enable = true;
      interval = "hourly";
      includeStore = true;
    };
    mpd.enable = true;
		udisks2.enable = true;
		fail2ban = {
      enable = true;
      jails = {
        # this is predefined
        ssh-iptables = ''
          enabled  = true
        '';
      };
    };
    openssh = {
      enable = true;
      permitRootLogin = "yes";
			passwordAuthentication = false;
    };
    
    openvpn.servers.torguard = {
      config = ''
        client
        dev tun
        proto udp
        remote ro.torguardvpnaccess.com 443
        resolv-retry infinite
        remote-cert-tls server
        nobind
        tun-mtu 1500
        tun-mtu-extra 32
        mssfix 1450
        ca /etc/nixos/certs/torguard.crt
        auth-user-pass
        comp-lzo
        fast-io
        ping-restart 0
        route-delay 2
        route-method exe
        script-security 3 system
        mute-replay-warnings
        verb 3
        dhcp-option DNS 208.67.222.222
      '';
      up = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
      down = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
      autoStart = false;
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql;
      enableTCPIP = true;
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

    upower.enable = true;
    nixosManual.showManual = true;

    # synchronize time using chrony
    ntp.enable = false;
    chrony.enable = true;
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
