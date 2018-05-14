{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreeRedistributable = true;

  environment.systemPackages = [
    pkgs.ack
    pkgs.ag
    pkgs.cloudfoundry-cli
    pkgs.fastlane
    pkgs.gitAndTools.git-extras
    pkgs.gitAndTools.gitFull
    pkgs.gitAndTools.gitflow
    pkgs.haskellPackages.gitHUD
    pkgs.htop
    pkgs.imagemagick
    pkgs.jdk
    pkgs.tree
    pkgs.minecraft
    pkgs.minecraft-server
    pkgs.nix-repl
    pkgs.nodejs-8_x
    pkgs.neovim
    pkgs.reattach-to-user-namespace
    pkgs.terminal-notifier
    pkgs.tmux
    pkgs.unrar
    pkgs.vimHugeX
    pkgs.wget
    pkgs.python3
    pkgs.rustup
    pkgs.python36Packages.neovim
    pkgs.fzf
  ];

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;

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
