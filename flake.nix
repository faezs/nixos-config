{
  description = "NixOS systems - Faez Shakil";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/bacbfd713b4781a4a82c1f390f8fe21ae3b8b95b";
     nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

     nixos-hardware.url = github:NixOS/nixos-hardware/master;
     home-manager.url = "github:nix-community/home-manager/release-21.11";
     home-manager.inputs.nixpkgs.follows = "nixpkgs";
     emacs-overlay.url = "github:nix-community/emacs-overlay";
     nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
     nixos-shell.url = "github:Mic92/nixos-shell";
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: let
    mkVM = import ./lib/mkvm.nix;

    overlays = [
      inputs.emacs-overlay.overlay
      (final: prev: {
        kitty = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.kitty;
      })
    ];
  in {
     nixosConfigurations.vm-aarch64 = mkVM "vm-aarch64" rec {
       inherit overlays nixpkgs home-manager;
       system = "aarch64-linux";
       user = "faezs";
     };

  };
}
