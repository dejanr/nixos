{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #vulkan-headers
    #vulkan-loader
    #vulkan-tools
    #vulkan-validation-layers
    #steam
    #steam-run
    #steamcontroller
    #sc-controller
    #haskellPackages.steambrowser
    #linux-steam-integration
    minecraft
    #playonlinux
    wineStaging
    winetricks
    evelauncher
  ];


  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = {
      playonlinux = pkgs.callPackage ../packages/playonlinux.nix {};
      evelauncher = pkgs.callPackage ../packages/evelauncher.nix {};
    };
  };

  services = {
    minecraft-server = {
      enable = false;
    };
  };
}
