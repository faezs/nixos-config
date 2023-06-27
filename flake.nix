{
  description = "NixOS systems - Faez Shakil";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
     nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
     agda-nixpkgs.url = "github:nixos/nixpkgs/1ffba9f2f683063c2b14c9f4d12c55ad5f4ed887";
     
     sops-nix.url = "github:Mic92/sops-nix";
     nixos-hardware.url = github:NixOS/nixos-hardware/master;
     home-manager.url = "github:nix-community/home-manager";
     emacs-overlay.url = "github:nix-community/emacs-overlay";
     nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
     nixos-shell.url = "github:Mic92/nixos-shell";
     agda-stdlib = { url = "github:agda/agda-stdlib"; flake = false; };
     agda-unimath = { url = "github:UniMath/agda-unimath"; flake = false; };
     denotational-hardware = { url = "github:conal/denotational-hardware"; flake = false; };
     agda-cubical = { url = "github:agda/cubical"; };
     copilot-el = { url = "github:zerolfx/copilot.el"; flake = false; };
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, nix-doom-emacs, sops-nix, ... }: let
    mkVM = import ./lib/mkvm.nix;

    overlays = [
      inputs.emacs-overlay.overlay
      (final: prev: {
        kitty = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.kitty;
        agda = inputs.agda-nixpkgs.legacyPackages.${prev.system}.agda;
      })
    ];
  in {
     nixosConfigurations.vm-aarch64 = mkVM "vm-aarch64" rec {
       inherit overlays home-manager inputs sops-nix;
       nixpkgs = inputs.nixpkgs-unstable;
       system = "aarch64-linux";
       user = "faezs";
     };
     nixosConfigurations.vm-x86_64 = mkVM "vm-x86_64" rec {
       inherit overlays home-manager inputs sops-nix;
       nixpkgs = inputs.nixpkgs-unstable;
       system = "x86_64-linux";
       user = "faezs";
     };

     nixosConfigurations.vm-x86_64-utm = mkVM "vm-x86_64-utm" rec {
       inherit overlays home-manager inputs sops-nix;
       nixpkgs = inputs.nixpkgs-unstable;
       system = "x86_64-linux";
       user = "faezs";
     };
  };
}
