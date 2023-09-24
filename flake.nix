{
  description = "NixOS systems - Faez Shakil";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agda-nixpkgs.url = "github:nixos/nixpkgs/1ffba9f2f683063c2b14c9f4d12c55ad5f4ed887";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    nixos-shell.url = "github:Mic92/nixos-shell";
    nixos-shell.inputs.nixpkgs.follows = "nixpkgs";
    agda-stdlib = {
      url = "github:agda/agda-stdlib";
      flake = false;
    };
    agda-unimath = {
      url = "github:UniMath/agda-unimath";
      flake = false;
    };
    felix = {
      url = "github:conal/felix";
      flake = false;
    };
    agda-cubical = { url = "github:agda/cubical"; };
    copilot-el = {
      url = "github:zerolfx/copilot.el";
      flake = false;
    };
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, nix-doom-emacs, sops-nix, ... }:
    let
      mkVM = import ./lib/mkvm.nix;

      overlays = [
        # inputs.emacs-overlay.overlay
        (final: prev: {
          nix = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.nix;
          agda = inputs.agda-nixpkgs.legacyPackages.${prev.system}.agda;
        })
      ];
    in {
      nixosConfigurations.vm-aarch64 = mkVM "vm-aarch64" rec {
        inherit overlays home-manager inputs sops-nix;
        nixpkgs = inputs.nixpkgs;
        system = "aarch64-linux";
        user = "faezs";
      };
      nixosConfigurations.vm-x86_64 = mkVM "vm-x86_64" rec {
        inherit overlays home-manager inputs sops-nix;
        nixpkgs = inputs.nixpkgs;
        system = "x86_64-linux";
        user = "faezs";
      };

      nixosConfigurations.vm-x86_64-utm = mkVM "vm-x86_64-utm" rec {
        inherit overlays home-manager inputs sops-nix;
        nixpkgs = inputs.nixpkgs;
        system = "x86_64-linux";
        user = "faezs";
      };
    };
}
