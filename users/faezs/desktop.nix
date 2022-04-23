{ config, pkgs, lib, ... }:

{
  hardware.video.hidpi.enable = true;
  services.xserver.dpi = 170;

  systemd.user.services.polybar = {
    enable = true;
    description = "Polybar";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polybar}/bin/polybar -c /etc/nixos/config/polybar example";
      Restart = "on-abnormal";
    };
  };


  fonts = {
    fonts = with pkgs; [
      siji
    ];
  };
  environment.systemPackages = with pkgs; [
    polybar
    xorg.xdpyinfo
    xorg.xrandr
    arandr
    autorandr
    xclip
    xsel
    dmenu
    gmrun
    dzen2
  ];



}