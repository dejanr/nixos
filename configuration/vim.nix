{ config, lib, pkgs, ... }:

{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    (import ./vim)
    ctags
    silver-searcher
    fzf
    haskellPackages.ghc-mod
    haskellPackages.hlint
    haskellPackages.hdevtools
  ];
}
