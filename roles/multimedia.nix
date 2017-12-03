{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    alsaLib
    alsaPlugins
    alsaUtils
    ardour
    audacity
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
    pavucontrol # volume control
    puredata
    qjackctl
    vlc
  ];
}
