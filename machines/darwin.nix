{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [ (import ../packages) ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreeRedistributable = true;

  environment.systemPackages = [
    pkgs.nix-repl
    pkgs.haskellPackages.gitHUD
    pkgs.tmux
    pkgs.vimHugeX
    pkgs.gitAndTools.gitFull
    pkgs.gitAndTools.git-extras
    pkgs.gitAndTools.gitflow
    pkgs.nodejs-8_x
    pkgs.imagemagick
    pkgs.fastlane
    pkgs.jdk
    pkgs.ag
    pkgs.ack
    pkgs.minecraft
    pkgs.minecraft-server
    pkgs.reattach-to-user-namespace
    pkgs.htop
  ];

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 22;
  system.defaults.NSGlobalDomain.KeyRepeat = 12;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "left";
  system.defaults.dock.showhidden = false;
  system.defaults.dock.mru-spaces = false;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;

  programs.bash.enable = true;
  programs.nix-index.enable = true;

  services.activate-system.enable = true;
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 2;

  nix.maxJobs = 4;
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    gc-keep-derivations = true
    gc-keep-outputs = true
  '';
  nix.nixPath = [
    "darwin-config=/etc/nixos/machines/darwin.nix"
    "darwin=/etc/nixos/darwin"
    "nixpkgs=/etc/nixos/nixpkgs"
  ];
}
