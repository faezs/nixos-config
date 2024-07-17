{
  description = "NixOS systems - Faez Shakil";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agda-nixpkgs.url = "github:nixos/nixpkgs/1ffba9f2f683063c2b14c9f4d12c55ad5f4ed887";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    nix-straight = {
      url = "github:codingkoi/nix-straight.el?ref=codingkoi/apply-librephoenixs-fix";
      flake = false;
    };
    nix-doom-emacs.inputs.nix-straight.follows = "nix-straight";
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
      url = "github:muqadma/felix";
      flake = false;
    };
    agda-cubical = { url = "github:agda/cubical"; };
    copilot-el = {
      url = "github:zerolfx/copilot.el";
      flake = false;
    };
    muqadma = { url = "git+file:///home/faezs/jinnah/muqadma"; };
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, nix-doom-emacs, sops-nix, ... }:
    let

     flex = ps: (ps.mkDerivation {
                pname = "felix";
                version = "1.0.0";
                src = inputs.felix;
                meta = {};
                preBuild = ''
                  sed -i 's/standard-library-2.0/standard-library/' ./felix.agda-lib
                  sed -i 's/open import Relation.Binary.PropositionalEquality/open import Relation.Binary.PropositionalEquality hiding (Extensionality)/g' ./src/Felix/Instances/Function/Laws.agda
                  '';
                everythingFile = "./src/Felix/All.agda";
                libraryFile = "./felix.agda-lib";
                buildInputs = [
                  ps.standard-library
                ];
      });

      mkVM = import ./lib/mkvm.nix;

      overlays = [
        # inputs.emacs-overlay.overlay
        (final: prev: {
          nix = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.nix;

          agda = inputs.agda-nixpkgs.legacyPackages.${prev.system}.agda.withPackages (ps: [
              (ps.standard-library)
              (flex ps)
          ]);
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
