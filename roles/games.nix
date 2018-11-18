{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unstable.steam
    unstable.steam-run
    unstable.steamcontroller
    unstable.sc-controller
    unstable.minecraft
    unstable.playonlinux
    unstable.wineStaging
    unstable.winetricks
  ];


  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = {
      playonlinux = pkgs.callPackage ../packages/playonlinux.nix {};
    };
  };

  services = {
    minecraft-server = {
      enable = false;
    };
  };
}
