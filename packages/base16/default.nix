{ stdenv, fetchgit, fetchurl, ruby, which }:

stdenv.mkDerivation rec {
  rev = "9b24598c08a27780f87c318e6145c1468b9880ba";
  name = "base16-2015-09-29_${rev}";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/chriskempson/base16-builder";
    sha256 = "05wyf0qz5z3n3g8lz2rd1b6gv6v7qjaazwjm0w4ib4anj4v026sd";
  };

  patches = [
    (fetchurl {
        url = "https://github.com/chriskempson/base16-builder/pull/341.patch";
        sha256 = "1r7i22qr5maxnp8a84mwin0a48klb8fym2hkw15ichkqfn3cdqdn";
      })
    (fetchurl {
        url = "https://github.com/chriskempson/base16-builder/pull/331.patch";
        sha256 = "0hbyc9i62ihms00rk1ap0apjw8zf5axrvsk63vdy1hfyd9n5y2yf";
      })
    (fetchurl {
        url = "https://github.com/chriskempson/base16-builder/pull/330.patch";
        sha256 = "1gfsbrxzdk3pz9dmyxismc3mzgm0cz8pkmf52iz4s9gq7vkv1d14";
      })
    (fetchurl {
        url = "https://github.com/chriskempson/base16-builder/pull/325.patch";
        sha256 = "0n10yzm0n4g77z29s5f69261qy6x6kkjc6nj6ccdjlncz0bk6d8k";
      })
    (fetchurl {
        url = "https://github.com/chriskempson/base16-builder/pull/318.patch";
        sha256 = "0c044bimdbiw2n2nzzivzrvxhwk6i93lc4ydah56xhs6pp1x0i60";
      })
  ];

  buildInputs = [ ruby which ];

  buildPhase = ''
    patchShebangs base16
    ./base16
  '';

  installPhase = ''
    mkdir -p $out
    cp output/* $out -R
  '';
}
