{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ag
    ack
    aspell
    aspellDicts.de
    aspellDicts.en
    atop
    autoconf
    autojump # cd command that learns
    automake
    awscli
    s3cmd
    s3fs
    s3ql
    unfs3
    s3fs
    bash
    bind
    binutils
    clang
    cmake
    connect # Make network connection via SOCKS and https proxy
    coreutils
    ctags
    curl
    darcs
    dpkg
    docker
    pythonPackages.docker_compose
    emacs
    ettercap # Comprehensive suite for man in the middle attacks
    file # show file type
    fish
    gcc
    graphicsmagick # Swiss army knife of image processing
    gdb
    gforth
    git
    gitAndTools.git-extras
    gitAndTools.gitflow
    gitFull
    gnumake
    go
    gparted
    htop
    haskellPackages.ghc # The Glasgow Haskell Compiler
    haskellPackages.cabal-install # The command-line interface for Cabal and Hackage
    stack # The Haskell Tool Stack
    iftop
    imagemagickBig
    iotop
    llvm
    lshw
    lsof
    meld # visual diff and merge tool
    mercurial
    mosh # mobile shell, ssh replacement
    mr # multiple repository managment
    ncftp
    ngrep # network packet alalyzer
    nix-prefetch-scripts
    nix-repl
    nmap # network discovery and security audit
    nodejs-8_x # Event-driven I/O framework for the V8 JavaScript engine
    nox # tools to make nix nicer
    obs-studio # video recording and live streaming
    openssl
    patchelf
    psmisc
    python
    ranger # file manager with minimal ncurses interface
    ruby
    smartmontools # tools for monitoring hard drives
    tcpdump # network sniffer
    telnet
    tmux
    tree
    usbutils
    wget
    which
    wireshark # network protocol analyzer
  ];
}
