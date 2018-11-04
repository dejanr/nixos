{
  # pkg set to use
  pkgs ? import <nixos> {}
  # whether to use a fhs chroot to run eve
  , buildInFhs ? false
}:

let
  inherit (pkgs) makeWrapper stdenv fetchurl;
  buildDeps = pkgs: with pkgs; [
    bash
    coreutils
    gtk2
    glib
    udev
    xorg.libX11
    xorg.libXt
    xorg.libXi
    xorg.libXft
    xorg.libXext
    xorg.libXtst
    xorg.libXcursor
    xorg.libXfixes
    xorg.libXrender
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libSM
    xorg.libICE
    xorg.libXau
    libxml2
    libxslt
    libzip
    zlib
    alsaLib
    alsaPlugins
    dbus
    qwt
    qt5.full
    xxkb
    openssl
    libxkbcommon
    nss
    nspr
    fontconfig
    freetype
    openldap
    libpulseaudio

    makeWrapper
    patchelf

    libGL
    expat
    xorg.libXScrnSaver
    xorg.libXdmcp
  ];

  fhs = pkgs.buildFHSUserEnv rec {
    name = "eve-env";
    targetPkgs = buildDeps;
    multiPkgs = targetPkgs; # for now install 32bit and 64bit for everything

    runScript = "${eve}/bin/evelauncher.sh";
    profile = ''
      export QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb
    '';
  };

eve = stdenv.mkDerivation rec {
  name = "eve-launcher-${version}";
  version = "1385477";

  src = fetchurl {
    url = "https://binaries.eveonline.com/evelauncher-${version}.tar.gz";
    sha256 = "0aycrkyhfci05w1p2h2983ahw7qn4wi40j5in6mvzrkjhzl5n5km";
  };

  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = [ makeWrapper ];

  installPhase =''
    mkdir -p $out/bin/
    mkdir -p $out/share/

    # mv evelauncher $out/bin
    # mv * $out/share

    mv * $out/bin

    # wrapProgram $out/bin/evelauncher \
    #   --prefix QTDIR=$out/share \
    #   --prefix QT_PLUGIN_PATH=$out/share/plugins
  '';
};

# doesn't work yet without fhs. Binary downloaded by the launcher needs to be patched in order to run
eve-native = stdenv.mkDerivation rec {
  name = "eve-launcher-${version}";
  version = "1385477";

  src = fetchurl {
    url = "https://binaries.eveonline.com/evelauncher-${version}.tar.gz";
    sha256 = "0aycrkyhfci05w1p2h2983ahw7qn4wi40j5in6mvzrkjhzl5n5km";
  };

  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = buildDeps pkgs;

  libPath = stdenv.lib.makeLibraryPath buildInputs;

  installPhase =''
    mkdir -p $out/bin/
    mkdir -p $out/share/

    mv evelauncher $out/bin
    mv * $out/bin

    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $out/bin:${libPath}:$out/bin:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib \
      $out/bin/evelauncher

    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $out/bin:${libPath}:$out/bin:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib \
      $out/bin/QtWebEngineProcess

    for i in $out/bin/lib*.so; do
      echo patch $i
      patchelf \
        --set-rpath $out/bin:${libPath}:$out/bin:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib \
        $i
    done

    wrapProgram $out/bin/evelauncher \
      --prefix LD_LIBRARY_PATH : ${libPath} \
      --prefix LD_LIBRARY_PATH : $out/bin \
      --prefix QT_XKB_CONFIG_ROOT : ${pkgs.xorg.libX11}/share/X11/xkb \
      --prefix QTDIR : $out/bin \
      --prefix tmp : /home/dejanr/.local/tmp \
      --prefix QT_PLUGIN_PATH : $out/bin/plugins
  '';
};

# in fhs
in (if buildInFhs then fhs else eve-native)
