{ pkgs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  # environment.pathsToLink = [ "/share/fish" ];

  users.mutableUsers = true;
  users.users.faezs = {
    isNormalUser = true;
    home = "/home/faezs";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.bash;
  };

  # nixpkgs.overlays = import ../../lib/overlays.nix;
}