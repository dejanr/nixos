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
    gst_ffmpeg
    gst_plugins_bad
    gst_plugins_base
    gst_plugins_good
    gst_plugins_ugly
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
