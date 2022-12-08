{
  description = "NixOS systems - Faez Shakil";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/bacbfd713b4781a4a82c1f390f8fe21ae3b8b95b";
     nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
     agda-nixpkgs.url = "github:nixos/nixpkgs/1ffba9f2f683063c2b14c9f4d12c55ad5f4ed887";
     

     nixos-hardware.url = github:NixOS/nixos-hardware/master;
     home-manager.url = "github:nix-community/home-manager";
     emacs-overlay.url = "github:nix-community/emacs-overlay";
     nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
     nixos-shell.url = "github:Mic92/nixos-shell";
     agda-stdlib = { url = "github:agda/agda-stdlib"; flake = false; };
     agda-unimath = { url = "github:UniMath/agda-unimath"; flake = false; };
     denotational-hardware = { url = "github:conal/denotational-hardware"; flake = false; };
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, nix-doom-emacs, ... }: let
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
       inherit overlays home-manager inputs;
       nixpkgs = inputs.nixpkgs-unstable;
       system = "aarch64-linux";
       user = "faezs";
     };
     nixosConfigurations.vm-x86_64 = mkVM "vm-x86_64" rec {
       inherit overlays home-manager inputs;
       nixpkgs = inputs.nixpkgs-unstable;
       system = "x86_64-linux";
       user = "faezs";
     };

     nixosConfigurations.vm-x86_64-utm = mkVM "vm-x86_64-utm" rec {
       inherit overlays home-manager inputs;
       nixpkgs = inputs.nixpkgs-unstable;
       system = "x86_64-linux";
       user = "faezs";
     };
  };
}
