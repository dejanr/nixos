self: super:

let callPackage = super.newScope self; in rec {
  base16 = super.callPackage ./base16/default.nix { };
  rofi-menugen = super.callPackage ./rofi-menugen/default.nix { };

  rofi = super.rofi.override { i3Support = true; };
}
