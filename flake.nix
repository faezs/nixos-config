{
  description = "NixOS systems - Faez Shakil";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/5181d5945eda382ff6a9ca3e072ed6ea9b547fee";

     nixos-hardware.url = github:NixOS/nixos-hardware/master;
     home-manager.url = "github:nix-community/home-manager";
     home-manager.inputs.nixpkgs.follows = "nixpkgs";
     emacs-overlay.url = "github:nix-community/emacs-overlay";	
     nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
     nixos-shell.url = "github:Mic92/nixos-shell";
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: let
    mkVM = import ./lib/mkvm.nix;

    overlays = [
      inputs.emacs-overlay.overlay
    ];
  in {
     nixosConfigurations.vm-aarch64 = mkVM "vm-aarch64" rec {
       inherit overlays nixpkgs home-manager;
       system = "aarch64-linux";
       user = "faezs";
     };

  };
}
