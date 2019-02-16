{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    alsaLib
    alsaPlugins
    alsaUtils
    ardour
    audacity
    blueman
    calf
    ffmpeg
    handbrake
    jack2Full
    ladspaPlugins
    libdvdcss
    libdvdnav
    libdvdread
    mplayer
    pamixer # cli tools for pulseaudio
    paprefs
    pavucontrol # volume control
    puredata
    qjackctl
    vlc
  ];

  hardware.bluetooth = {
    enable = true;
  };

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    # https://nixos.wiki/wiki/Bluetooth#Using_Bluetooth_headsets_with_PulseAudio
    package = pkgs.pulseaudioFull;
  };
}
