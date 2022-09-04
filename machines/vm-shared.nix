{ config, pkgs, currentSystem, lib, ... }:

{
  # We require 5.14+ for VMware Fusion on M1.
  boot.kernelPackages = pkgs.linuxPackages_5_15;

  # use unstable nix so we can access flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
     "experimental-features = nix-command flakes";
    trustedUsers = [ "root" "faezs" ];
    binaryCaches = ["https://cache.garnix.io" "https://nixcache.reflex-frp.org" ];
    binaryCachePublicKeys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
   };

  # We expect to run the VM on hidpi machines.
  hardware.video.hidpi.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "qrn";

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Virtualization settings
  virtualisation.docker.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";


  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.mutableUsers = false;

  # Manage fonts. We pull these from a secret directory since most of these
  # fonts require a purchase.
  fonts = {
    fontDir.enable = true;

    fonts = [
      pkgs.fira-code
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnumake
    killall
    niv
    rxvt_unicode
    xclip
    zip
    unzip
    # This is needed for the vmware user tools clipboard to work.
    # You can test if you don't need this by deleting this and seeing
    # if the clipboard sill works.
    gtkmm3

    # VMware on M1 doesn't support automatic resizing yet and on
    # my big monitor it doesn't detect the resolution either so we just
    # manualy create the resolution and switch to it with this script.
    # This script could be better but its hopefully temporary so just force it.
    # (writeShellScriptBin "xrandr-6k" ''
    #   xrandr --newmode "6016x3384_60.00"  1768.50  6016 6544 7216 8416  3384 3387 3392 3503 -hsync +vsync
    #   xrandr --addmode Virtual-1 6016x3384_60.00
    #   xrandr -s 6016x3384_60.00
    # '');
    (writeShellScriptBin "xrandr-mbp" ''
      xrandr --newmode "3456x2234_60.00"  664.00  3456 3744 4120 4784  2234 2237 2247 2314 -hsync +vsync
      xrandr --addmode Virtual-1 "3456x2234_60.00"
      xrandr -s 3456x2234_60.00
    '')
  ];

  environment.variables = {
    GDK_SCALE = "0.5";
    GDK_DPI_SCALE = "0.5";
  };
  
  services.xserver = {
    enable = true;
    dpi = 254;

    resolutions = [
      { x = 3456;
        y = 2234;
      }
    ];

    displayManager = {
      defaultSession = "none+xmonad";
      lightdm.enable = true;
      sessionCommands = ''
        ${pkgs.xlibs.xset}/bin/xset r rate 200 40
      ''+(if currentSystem == "aarch64-linux" then ''
        ${pkgs.xorg.xrandr}/bin/xrandr -s '3456x2234'
      '' else "");
    };

    desktopManager = {
      xterm.enable = true;
      wallpaper.mode = "scale";
    };
    
    windowManager.xmonad = {
      enable = true;
      haskellPackages = pkgs.haskellPackages.extend
        (import ../users/faezs/xmonad-conf/overlay.nix { inherit pkgs; });
      extraPackages = hpkgs: with pkgs.haskell.lib; [
        hpkgs.xmonad-contrib
        hpkgs.xmonad-extras
      ];
      # enableContribAndExtras = true;  -- using our own
      config = pkgs.lib.readFile ../users/faezs/xmonad-conf/Main.hs;
    };
  };
  
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "no";

  # Disable the firewall since we're in a VM and we want to make it
  # easy to visit stuff in here. We only use NAT networking anyways.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
