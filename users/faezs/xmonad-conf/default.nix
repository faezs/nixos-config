# Since the xmonad config will be built by nixos-rebuild, we use the
# nix-channel's nixpkgs.
{ pkgs ? import <nixpkgs> { } }:
let
  haskellOverlays = import ./overlay.nix { inherit pkgs; };
in
# FIXME: overlays not working
(pkgs.haskellPackages.extend haskellOverlays).developPackage {
  name = "xmonad-conf";
  root = ./.;
  modifier = drv:
    pkgs.haskell.lib.addBuildTools drv (with pkgs.haskellPackages;
    [
      cabal-install
      cabal-fmt
      ghcid
      haskell-language-server
    ]);
}