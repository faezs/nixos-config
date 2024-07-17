{ pkgs, ... }:

{ # https://github.com/nix-community/home-manager/pull/2408
  # environment.pathsToLink = [ "/share/fish" ];

  users.mutableUsers = true;
  users.users.faezs = {
    isNormalUser = true;
    home = "/home/faezs";
    extraGroups = [ "docker" "wheel" "scanner" "lp" "keys" ];
    shell = pkgs.bash;
  };

  hardware.sane.drivers.scanSnap.enable = true;
  # the below may be necessary
  nixpkgs.config.sane.snapscanFirmware = pkgs.fetchurl {
    # https://wiki.ubuntuusers.de/Scanner/Epson_Perfection/#Unterstuetzte-Geraete
    url = "https://media-cdn.ubuntu-de.org/wiki/attachments/52/46/Esfw41.bin"; #Epson Perfection 2480
    sha256 = "00cv25v4xlrgp3di9bdfd07pffh9jq2j0hncmjv3c65m8bqhjglq";
  };
  # nixpkgs.overlays = import ../../lib/overlays.nix;
}
