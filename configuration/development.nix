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
    docker
    emacs
    ettercap # Comprehensive suite for man in the middle attacks
    file # show file type
    fish
    gcc
    gdb
    gforth
    git
    gitAndTools.git-extras
    gitFull
    gnumake
    go
    gparted
    htop
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
    nodejs
    nox # tools to make nix nicer
    obs-studio # video recording and live streaming
    openssl
    pandoc # convertion between markup formats
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
    vim
    wget
    which
    wireshark # network protocol analyzer
  ];
}
