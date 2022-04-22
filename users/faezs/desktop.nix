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
    pkgs.polybar
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

  services.xserver = {
    enable = true;
    
    displayManager = {
      lightdm.enable = true;
      sessionCommands = ''
        ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
            Xft.dpi: 192
	    Xcursor.theme: Adawaita
	    Xcursor.size: 64
        EOF	
      '';
    };
    windowManager.xmonad = {
      enable = true;
      haskellPackages = pkgs.haskellPackages.extend
        (import ./xmonad-conf/overlay.nix { inherit pkgs; });
      extraPackages = hpkgs: with pkgs.haskell.lib; [
        hpkgs.xmonad-contrib
        hpkgs.xmonad-extras
      ];
      # enableContribAndExtras = true;  -- using our own
      config = pkgs.lib.readFile ./xmonad-conf/Main.hs;
    };
  };
  services.xserver.displayManager.defaultSession = "none+xmonad";

}