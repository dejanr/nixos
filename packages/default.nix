{ pkgs ? import <nixpkgs> {} }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // headcounter);

  custom = rec {
    base16 = pkgs.callPackage ./base16/default.nix { };
    rofi-menugen = pkgs.callPackage ./rofi-menugen/default.nix { };

    rofi = pkgs.rofi.override { i3Support = true; };
  };
in pkgs // {
  inherit custom;
}
