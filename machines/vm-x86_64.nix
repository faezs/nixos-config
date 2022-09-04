{ config, pkgs, ... }: {
  imports = [
    ./vm-shared.nix
  ];

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
}