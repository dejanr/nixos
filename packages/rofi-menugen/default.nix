{ stdenv, fetchgit, fetchurl, ruby, which }:

stdenv.mkDerivation rec {
  rev = "3ab7e661385331b84a5345df8055d59f741a27cb";
  name = "rofi-menugen-2015-12-28-${rev}";

  src = pkgs.fetchFromGitHub {
    owner = "octotep";
    repo = "menugen";
    inherit rev;
    sha256 = "bfa8dccdc7fbc754019394e69c552d071ababa6868a056f1e61a60f3208585d8";
  };

  buildInputs = with pkgs; [ rofi gnused ];
  patchPhase = ''
    sed -i -e "s|menugenbase|$out/bin/rofi-menugenbase|" menugen
    sed -i -e "s|rofi |${pkgs.rofi}/bin/rofi |" menugen
    sed -i -e "s|sed |${pkgs.gnused}/bin/sed |" menugenbase
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp menugen $out/bin/rofi-menugen
    cp menugenbase $out/bin/rofi-menugenbase
  '';
}
